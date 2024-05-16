//
//  RestaurantViewModel.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import Foundation
import FirebaseFirestore

class RestaurantViewModel: ObservableObject {
    @Published var restaurants = [Restaurant]()

    private var db = Firestore.firestore()

    func fetchData(phone: String) {
        db.collection("restaurant")
          .whereField("phone", isEqualTo: phone)
          .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.restaurants = documents.map { queryDocumentSnapshot -> Restaurant in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let lastCheckin = (data["lastCheckin"] as? Timestamp)?.dateValue() ?? Date()
                let currentCheckins = data["currentCheckins"] as? Int ?? 0
                let targetCheckins = data["targetCheckins"] as? Int ?? 0
                let phone = data["phone"] as? String ?? ""
                let reward = data["reward"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                let registeredId = data["registeredId"] as? String ?? ""

                return Restaurant(id: queryDocumentSnapshot.documentID, title: title, image: image, lastCheckin: lastCheckin, currentCheckins: currentCheckins, targetCheckins: targetCheckins, phone: phone, reward: reward, status: status, registeredId: registeredId)
            }
        }
    }
    
    func saveData(restaurant: Restaurant, phoneNumber: String) {
        let ref = db.collection("restaurant").document()  // Creating a new document
        ref.setData([
            "title": restaurant.title,
            "image": restaurant.image,
            "lastCheckin": Timestamp(date: restaurant.lastCheckin),
            "currentCheckins": restaurant.currentCheckins,
            "targetCheckins": restaurant.targetCheckins,
            "phone": phoneNumber,
            "reward": restaurant.reward,
            "status": restaurant.status,
            "registeredId": restaurant.registeredId
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteData(restaurantId: String, phone: String, completion: @escaping () -> Void) {
       db.collection("restaurant").document(restaurantId).delete() { error in
           if let error = error {
               print("Error removing document: \(error)")
           } else {
               print("Document successfully removed!")
               completion()
           }
       }
   }
    
    func checkin(code: String, phoneNumber: String, restaurant: Restaurant, completion: @escaping (Bool, String, Bool) -> Void) {
        // Step 1: Check the current check-ins and target check-ins
        guard restaurant.currentCheckins < restaurant.targetCheckins else {
            completion(false, "No matching restaurant or maximum check-ins reached.", false)
            return
        }

        // Step 2: Validate the check-in code
        db.collection("registered-restaurant").document(restaurant.registeredId).getDocument { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists, error == nil else {
                completion(false, "No registered restaurant found.", false)
                return
            }

            let registeredRestaurant = try? document.data(as: RegisteredRestaurant.self)
            guard let checkinCode = registeredRestaurant?.checkinCode, checkinCode == code else {
                completion(false, "Check-in code is not correct.", false)
                return
            }

            // Step 3: Update the restaurant check-in count and status
            self.updateCheckinCountAndStatus(restaurant: restaurant, completion: completion)
        }
    }

    private func updateCheckinCountAndStatus(restaurant: Restaurant, completion: @escaping (Bool, String, Bool) -> Void) {
        let restaurantRef = db.collection("restaurant").document(restaurant.id!)
        db.runTransaction({ (transaction, errorPointer) -> Any? in

            var newCheckins = restaurant.currentCheckins + 1
            var newStatus = restaurant.status
            if newCheckins >= restaurant.targetCheckins {
                newStatus = "COMPLETED"
            }

            transaction.updateData(["currentCheckins": newCheckins, "status": newStatus], forDocument: restaurantRef)
            completion(true, "Check-in successful and completed.", newStatus == "COMPLETED")
            return nil
        }) { _, error in
            if let error = error {
                completion(false, "Failed to update restaurant: \(error.localizedDescription)", false)
            } else {
                completion(true, "Check-in successful.", false)
            }
        }
    }
}


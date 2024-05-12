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

                return Restaurant(id: queryDocumentSnapshot.documentID, title: title, image: image, lastCheckin: lastCheckin, currentCheckins: currentCheckins, targetCheckins: targetCheckins, phone: phone, reward: reward, status: status)
            }
        }
    }
    
    func saveData(restaurant: Restaurant) {
        let ref = db.collection("restaurant").document()  // Creating a new document
        ref.setData([
            "title": restaurant.title,
            "image": restaurant.image,
            "lastCheckin": Timestamp(date: restaurant.lastCheckin),
            "currentCheckins": restaurant.currentCheckins,
            "targetCheckins": restaurant.targetCheckins,
            "phone": restaurant.phone,
            "reward": restaurant.reward,
            "status": restaurant.status
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteData(restaurantId: String, phone: String) {
       db.collection("restaurant").document(restaurantId).delete() { error in
           if let error = error {
               print("Error removing document: \(error)")
           } else {
               print("Document successfully removed!")
               DispatchQueue.main.async {
                   self.fetchData(phone: phone)
               }
           }
       }
   }
    
    func updateCheckin(restaurantId: String, phone: String) {
            let query = db.collection("restaurant")
                .whereField("id", isEqualTo: restaurantId)
                .whereField("phone", isEqualTo: phone)
            
            query.getDocuments { snapshot, error in
                guard let document = snapshot?.documents.first else {
                    print("No document found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let transactionBlock: (Transaction, NSErrorPointer) -> Any? = { transaction, errorPointer in
                    let restaurantDocument: DocumentSnapshot
                    do {
                        restaurantDocument = try transaction.getDocument(document.reference)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    
                    guard let currentCheckins = restaurantDocument.data()?["currentCheckins"] as? Int else {
                        let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve current check-ins from document."
                        ])
                        errorPointer?.pointee = error
                        return nil
                    }
                    
                    transaction.updateData(["currentCheckins": currentCheckins + 1, "lastCheckin": Date()], forDocument: document.reference)
                    return nil
                }

                self.db.runTransaction(transactionBlock) { object, error in
                    if let error = error {
                        print("Transaction failed: \(error)")
                    } else {
                        print("Transaction successfully committed!")
                        self.fetchData(phone: phone)
                    }
                }
            }
        }

            
}


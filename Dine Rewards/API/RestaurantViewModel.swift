import Foundation
import FirebaseFirestore

/// RestaurantViewModel is a class responsible for managing restaurant data in the Dine Rewards app.
class RestaurantViewModel: ObservableObject {
    /// Published array of Restaurant objects to be used in SwiftUI views.
    @Published var restaurants = [Restaurant]()
    
    /// Firestore database reference.
    private var db = Firestore.firestore()
    
    /// Fetches restaurant data from Firestore for a given phone number.
    /// - Parameter phone: The phone number to filter the restaurant data.
    func fetchData(phone: String) {
        db.collection("restaurant")
            .whereField("phone", isEqualTo: phone)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                // Map Firestore documents to Restaurant objects.
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
    
    /// Saves new restaurant data to Firestore.
    /// - Parameters:
    ///   - restaurant: The Restaurant object containing the data to be saved.
    ///   - phoneNumber: The phone number associated with the restaurant.
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
    
    /// Deletes a restaurant document from Firestore.
    /// - Parameters:
    ///   - restaurantId: The ID of the restaurant document to be deleted.
    ///   - phone: The phone number associated with the restaurant.
    ///   - completion: Completion handler called after deletion.
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
    
    /// Handles check-in by validating the code and updating the restaurant's check-in count and status.
    /// - Parameters:
    ///   - code: The check-in code to be validated.
    ///   - phoneNumber: The phone number associated with the restaurant.
    ///   - restaurant: The Restaurant object to be checked in.
    ///   - completion: Completion handler with success status, message, and navigation flag.
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

    /// Updates the check-in count and status of the restaurant.
    /// - Parameters:
    ///   - restaurant: The Restaurant object to be updated.
    ///   - completion: Completion handler with success status, message, and navigation flag.
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

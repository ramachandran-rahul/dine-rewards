//
//  RegisteredRestaurantViewModel.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 13/5/24.
//

import Foundation
import FirebaseFirestore
import Firebase

/// ViewModel class for managing registered restaurants.
class RegisteredRestaurantViewModel: ObservableObject {
    /// Firestore database reference.
    private var db = Firestore.firestore()
    
    /// Searches for a registered restaurant by code and saves its data if found.
    /// - Parameters:
    ///   - phoneNumber: The phone number of the user.
    ///   - code: The code to search for the registered restaurant.
    ///   - completion: Completion handler with success status and message.
    func findAndRegisterRestaurant(phoneNumber: String, code: String, completion: @escaping (Bool, String) -> Void) {
        db.collection("registered-restaurant")
          .whereField("code", isEqualTo: code)
          .getDocuments { (snapshot, error) in
            if let error = error {
                // If there's an error fetching data, call completion with failure.
                completion(false, "Error fetching data: \(error.localizedDescription)")
            } else {
                if let document = snapshot?.documents.first {
                    let data = document.data()
                    // Extract restaurant details from the document.
                    guard let title = data["title"] as? String,
                          let image = data["image"] as? String,
                          let targetCheckins = data["targetCheckins"] as? Int,
                          let reward = data["reward"] as? String,
                          let _ = data["checkinCode"] as? String else {
                        print("Error: Document data missing or malformed")
                        return
                    }
                    
                    // Create a new Restaurant object with the retrieved data.
                    let newRestaurant = Restaurant(
                        id: document.documentID,
                        title: title,
                        image: image,
                        lastCheckin: Date(),
                        currentCheckins: 1,
                        targetCheckins: targetCheckins,
                        phone: phoneNumber,
                        reward: reward,
                        status: "IN_PROGRESS",
                        registeredId: document.documentID
                    )
                    
                    // Use the RestaurantViewModel to save this restaurant to the 'restaurant' collection.
                    let restaurantVM = RestaurantViewModel()
                    restaurantVM.saveData(restaurant: newRestaurant, phoneNumber: phoneNumber)
                    completion(true, "Register restaurant successfully")
                } else {
                    // If no matching restaurant is found, call completion with failure.
                    completion(false, "No matching restaurant found for the code provided.")
                }
            }
        }
    }
}

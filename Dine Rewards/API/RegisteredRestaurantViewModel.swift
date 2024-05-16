//
//  RegisteredRestaurantViewModel.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 13/5/24.
//

import Foundation
import FirebaseFirestore
import Firebase

class RegisteredRestaurantViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    // Function to search for a registered restaurant and save its data if found
    func findAndRegisterRestaurant(phoneNumber: String, code: String, completion: @escaping (Bool, String) -> Void) {
        db.collection("registered-restaurant")
          .whereField("code", isEqualTo: code)
          .getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, "Error fetching data: \(error.localizedDescription)")
            } else {
                if let document = snapshot?.documents.first {
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let image = data["image"] as? String,
                          let targetCheckins = data["targetCheckins"] as? Int,
                          let reward = data["reward"] as? String,
                          let _ = data["checkinCode"] as? String else {
                        print("Error: Document data missing or malformed")
                        return
                    }
                    
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
                    
                    // Use the RestaurantViewModel to save this restaurant to the 'restaurant' collection
                    let restaurantVM = RestaurantViewModel()
                    restaurantVM.saveData(restaurant: newRestaurant, phoneNumber: phoneNumber)
                    completion(true, "Register retaurant successfully")
                } else {
                    completion(false, "No matching restaurant found for the code provided.")
                }
            }
        }
    }
}

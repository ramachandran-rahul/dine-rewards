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

    func fetchData() {
        db.collection("restaurant").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.restaurants = documents.map { queryDocumentSnapshot -> Restaurant in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let lastCheckin = data["lastCheckin"] as? Date ?? Date()
                let currentCheckins = data["currentCheckins"] as? Int ?? 0
                let targetCheckins = data["targetCheckins"] as? Int ?? 0
                let phone = data["phone"] as? String ?? ""
                let reward = data["reward"] as? String ?? ""
                let status = data["status"] as? String ?? ""

                return Restaurant(id: queryDocumentSnapshot.documentID, title: title, image: image, lastCheckin: lastCheckin, currentCheckins: currentCheckins, targetCheckins: targetCheckins, phone: phone, reward: reward, status: status)
            }
        }
    }
}


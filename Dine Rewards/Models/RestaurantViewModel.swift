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
                print(data)
                let title = data["title"] as? String ?? ""
                let id = data["id"] as? String ?? ""
//                let expiryDate = data["expiryDate"] as? String ?? ""
//                let image = data["image"] as? String ?? ""

                return Restaurant(id: id, title: title)
            }
        }
    }
}

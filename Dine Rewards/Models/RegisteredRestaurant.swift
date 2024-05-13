//
//  RegisteredRestaurant.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 13/5/24.
//

import Foundation
import FirebaseFirestore

struct RegisteredRestaurant: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var image: String
    var targetCheckins: Int
    var reward: String
    var code: String
    var checkinCode: String
}

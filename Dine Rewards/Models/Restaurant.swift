//
//  Restaurant.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var image: String
    var lastCheckin: Date
    var currentCheckins: Int
    var targetCheckins: Int
    var phone: String
    var reward: String
    var status: String
    var registeredId: String
}

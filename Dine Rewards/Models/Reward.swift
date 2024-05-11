//
//  Reward.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import Foundation

struct Reward: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    let expiryDate: String
}

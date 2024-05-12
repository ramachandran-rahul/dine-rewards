//
//  UseRewardView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 12/5/24.
//

import SwiftUI

struct UseRewardView: View {
    var restaurant: Restaurant
    @EnvironmentObject var viewModel: RestaurantViewModel
        @Environment(\.presentationMode) var presentationMode
    var phoneNumber: String

    var body: some View {
        Image("sample-qr-code")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
        Spacer()
        Button("Use Reward") {
            viewModel.deleteData(restaurantId: restaurant.id, phone: phoneNumber)
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

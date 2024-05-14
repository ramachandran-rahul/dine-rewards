//
//  UseRewardView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 12/5/24.
//

import SwiftUI

struct UseRewardView: View {
    var restaurant: Restaurant
    var phoneNumber: String
    @State private var showRestaurantView = false

    @EnvironmentObject var viewModel: RestaurantViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
            VStack(spacing: 10) {
                Spacer()
                Text("Congratulations!")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundStyle(Color.white)
                Text("Here's your Reward!")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.white)
                VStack(spacing: 20) {
                    Text("Please show the restaurant staff the QR code below to redeem your reward and then click on the Use Reward button.")
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                    Image("sample-qr-code")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                    
                    Button("Use Reward") {
                        viewModel.deleteData(restaurantId: restaurant.id!, phone: phoneNumber, completion: {
                            showRestaurantView = true
                        })
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Spacer()
            }.background(Color.black)
            NavigationLink("", destination:  ListRestaurantView(phoneNumber: phoneNumber), isActive: $showRestaurantView).background(Color.black).frame(width: 200, height: 0)
    }
}

struct UseRewardView_Previews: PreviewProvider {
    static var previews: some View {
        UseRewardView(restaurant: sampleRestaurant, phoneNumber: "+614444444444")
    }

    static var sampleRestaurant: Restaurant {
        Restaurant(
            id: "1",
            title: "The Best Steakhouse",
            image: "https://i.ibb.co/n3HZnHW/food.jpg",
            lastCheckin: Date(),
            currentCheckins: 1,
            targetCheckins: 3,
            phone: "123-456-7890",
            reward: "Free Meal",
            status: "Active",
            registeredId: "J30aipdXEwOEdUbxhbJq"
        )
    }
}

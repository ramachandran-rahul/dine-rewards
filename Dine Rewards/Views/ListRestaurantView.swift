//
//  ListRewardsView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 10/5/24.
//

import SwiftUI
import AVFoundation

struct ListRestaurantView: View {
    @State private var showCodeRestaurant = false
    @ObservedObject var viewModel = RestaurantViewModel()
    var phoneNumber: String
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Restaurants")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .center)

                List {
                    ForEach(sortedRestaurants) { restaurant in
                        if restaurant.status == "COMPLETED" {
                            NavigationLink(destination: UseRewardView(restaurant: restaurant, phoneNumber: phoneNumber)) {
                               RestaurantRow(restaurant: restaurant)
                           }
                        }
                    }
        

                    if containsCompleted && containsOther {
                        Divider()
                    }

                    ForEach(sortedRestaurants) { restaurant in
                        if restaurant.status != "COMPLETED" {
                            NavigationLink(destination: CheckinView(restaurant: restaurant, phoneNumber: phoneNumber)) {
                               RestaurantRow(restaurant: restaurant)
                           }
                        }
                    }
                }
                .onAppear() {
                    viewModel.fetchData(phone: phoneNumber)
                }
                .listStyle(PlainListStyle())
                Button(action: {
                    self.showCodeRestaurant = true
                }) {
                    Text("Enter Restaurant Code")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .background(Color.black)
        }
        .sheet(isPresented: $showCodeRestaurant) {
            CodeRestaurantView(phoneNumber: phoneNumber, onCompletion: {
                showCodeRestaurant = false
            })
        }
    }
    
    var containsCompleted: Bool {
        viewModel.restaurants.contains(where: { $0.status == "COMPLETED" })
    }

    var containsOther: Bool {
        viewModel.restaurants.contains(where: { $0.status != "COMPLETED" })
    }

    var sortedRestaurants: [Restaurant] {
        viewModel.restaurants.sorted { $0.status == "COMPLETED" && $1.status != "COMPLETED" }
    }
    
    struct RestaurantRow: View {
        var restaurant: Restaurant
        
        var body: some View {
            HStack {
                AsyncImage(url: URL(string: restaurant.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(restaurant.title)
                        .font(.headline)
                    Text("Reward: \(restaurant.reward)")
                        .font(.subheadline)
                    Text("Progress: \(restaurant.currentCheckins)/\(restaurant.targetCheckins)")
                        .font(.subheadline)
                    Text("Status: \(restaurant.status)")
                        .font(.subheadline)
                }
            }
        }
    }

}

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
                
               ScrollView {
                    Text("Claim your Rewards")
                       .font(.title3)
                       .bold()
                       .foregroundStyle(Color.white)
                       .frame(maxWidth: .infinity, alignment: .leading)
                   Divider()
                        .frame(minHeight: 2)
                        .overlay(Color.white)
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
                    
                   Text("Check in to unlock these Rewards")
                      .font(.title3)
                      .bold()
                      .foregroundStyle(Color.white)
                      .frame(maxWidth: .infinity, alignment: .leading)
                  Divider()
                       .frame(minHeight: 2)
                       .overlay(Color.white)
                    ForEach(sortedRestaurants) { restaurant in
                        if restaurant.status != "COMPLETED" {
                            NavigationLink(destination: CheckinView(restaurant: restaurant, phoneNumber: phoneNumber)) {
                                RestaurantRow(restaurant: restaurant)
                            }
                        }
                    }
                }
               .padding()
                .onAppear() {
                    viewModel.fetchData(phone: phoneNumber)
                }
                .listStyle(PlainListStyle())
                Button(action: {
                    self.showCodeRestaurant = true
                }) {
                    Text("Add a Restaurant")
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
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2) // White border with rounded corners
                    )
                HStack {
                    AsyncImage(url: URL(string: restaurant.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 75, height: 75)
                    .cornerRadius(8)
                    .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(restaurant.title)
                            .font(.title3)
                        Text("Reward: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.reward)")
                            .font(.subheadline)
                        Text("Progress: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.currentCheckins)/\(restaurant.targetCheckins)")
                            .font(.subheadline)
                        Text("Status: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.status == "COMPLETED" ? "Reward Available" : "In Progress")")
                            .font(.subheadline)
                    }
                    .foregroundStyle(Color.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .padding(.vertical, 5)
        }
    }
}

struct ListRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        ListRestaurantView(phoneNumber: "+61 4444444444")
    }
}

//
//  ListRewardsView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 10/5/24.
//

import SwiftUI
import AVFoundation

struct ListRestaurantView: View {
    @State private var isShowingScanner = false
    @ObservedObject var viewModel = RestaurantViewModel()


    
    // Sample data for the list
//    let rewards = [
//        Restaurant(image: "gift", title: "Restaurant 1", description: "Get a free coffee with your next purchase", expiryDate: "Expires 06/15/2024"),
//        Restaurant(image: "ticket", title: "Restaurant 2", description: "20% off for your meal", expiryDate: "Expires 08/01/2024"),
//        Restaurant(image: "trophy", title: "Restaurant 3", description: "10% off on any drink", expiryDate: "Expires 12/25/2024")
//    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Restaurants")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .center)

                List(viewModel.restaurants) { reward in
                    HStack {
                        // Assuming you're using remote URLs for images
//                        AsyncImage(url: URL(string: reward.image)) { image in
//                            image.resizable()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 50, height: 50)
//                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(reward.title)
                                .foregroundColor(.white)
                                .font(.headline)
//                            Text(reward.description)
//                                .foregroundColor(.white)
//                                .font(.subheadline)
//                            Text("Expires on \(reward.expiryDate)")
//                                .foregroundColor(.gray)
//                                .font(.caption)
                        }
                    }
                }
                .onAppear() {
                    viewModel.fetchData()
                }
                .listStyle(PlainListStyle())
                Button(action: {
                    self.isShowingScanner = true
                }) {
                    Text("Scan QR Code")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .background(Color.black)
        }
        .sheet(isPresented: $isShowingScanner) {
            QRCodeScannerView()
        }
    }
}

struct ListRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        ListRestaurantView()
            .preferredColorScheme(.dark)
    }
}

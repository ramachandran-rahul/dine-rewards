//
//  ListRewardsView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 10/5/24.
//

import SwiftUI

struct ListRewardsView: View {
    // Sample data for the list
    let rewards = [
        Reward(image: "gift", title: "Free Coffee", description: "Get a free coffee with your next purchase", expiryDate: "Expires 06/15/2024"),
        Reward(image: "ticket", title: "Movie Night", description: "20% off on next movie ticket", expiryDate: "Expires 08/01/2024"),
        Reward(image: "trophy", title: "Champion's Discount", description: "10% off on sports items", expiryDate: "Expires 12/25/2024")
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Rewards")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .center)

                List(rewards) { reward in
                    NavigationLink(destination: CheckinView()) {
                        HStack {
                            Image(systemName: reward.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(reward.title)
                                    .font(.headline)
                                Text(reward.description)
                                    .font(.subheadline)
                                Text(reward.expiryDate)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }.cornerRadius(8)
                        }
                    }
                    .padding(.vertical)
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.black)
        }
    }
}

struct ListRewardsView_Previews: PreviewProvider {
    static var previews: some View {
        ListRewardsView()
            .preferredColorScheme(.dark)
    }
}

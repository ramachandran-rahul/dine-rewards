//
//  CheckinView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import SwiftUI
import AVFoundation

struct CheckinView: View {
    var restaurant: Restaurant
    @State private var isShowingScanner = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    AsyncImage(url: URL(string: restaurant.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    Text(restaurant.title)
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white.opacity(0.9))

                // Milestone rewards
                VStack(alignment: .leading, spacing: 10) {
                    Text("Next Milestone Reward")
                        .font(.headline)
                        .bold()
                    ForEach(0..<restaurant.targetCheckins, id: \.self) { index in
                        MilestoneView(
                            number: "\(index + 1) Check-in",
                            isCompleted: index < restaurant.currentCheckins
                        )
                    }
                    
                    Text(restaurant.reward).font(.headline)
                    
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.white)

                Button("Check-in") {
                      isShowingScanner = true
                  }
                  .padding()
                  .foregroundColor(.white)
                  .background(Color.blue)
                  .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $isShowingScanner) {
            CheckinScannerView()
        }
    }
}

struct MilestoneView: View {
    var number: String
    var isCompleted: Bool

    var body: some View {
        HStack {
            if isCompleted {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            } else {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
            VStack(alignment: .leading) {
                Text(number)
            }
        }
    }
}



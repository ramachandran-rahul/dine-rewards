//
//  CheckinView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import SwiftUI
import AVFoundation

struct CheckinView: View {
    @State private var isShowingScanner = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Image(systemName: "circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("7 Treasures Restaurant")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white.opacity(0.9))

                // Table status
                VStack(alignment: .leading, spacing: 10) {
                    Text("You’re at Table A1")
                        .font(.title3)
                        .bold()
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Last Check-in:")
                            Text("A moment ago")
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Next Milestone:")
                            Text("3 check-ins by 31 Dec")
                        }
                    }
                }
                .padding()
                .background(Color.pink.opacity(0.2))

                // Milestone rewards
                VStack(alignment: .leading, spacing: 10) {
                    Text("Next Milestone Reward")
                        .font(.headline)
                        .bold()
                    MilestoneView(number: "1st Check-in", date: "Complete by 31 Dec 2024")
                    MilestoneView(number: "2nd Check-in", date: "Complete by 31 Dec 2024")
                    MilestoneView(number: "3rd Check-in", date: "Complete by 31 Dec 2024")
                    Button(action: {}) {
                        Text("Get a surprise main dish and drink!")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.white)

                // Membership info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Membership:")
                    Text("Faye Wong")
                    Text("Joined 1 Apr 2024")
                }
                .padding()
                .background(Color.white)

                // Redeemables section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Redeemables (3)")
                        .font(.headline)
                        .bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            RedeemableView(title: "Free Welcome Drink", expiry: "Expires 31 Dec 2024")
                            RedeemableView(title: "Free Dessert", expiry: "Expires 31 Dec 2024")
                        }
                    }
                }
                .padding()
                .background(Color.white)
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
            .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $isShowingScanner) {
                    QRCodeScannerView()
                }
    }
}

struct MilestoneView: View {
    var number: String
    var date: String

    var body: some View {
        HStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: 20, height: 20)
            VStack(alignment: .leading) {
                Text(number)
                Text(date)
                    .font(.caption)
            }
        }
    }
}

struct RedeemableView: View {
    var title: String
    var expiry: String

    var body: some View {
        VStack {
            Image(systemName: "gift")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Text(title)
                .font(.caption)
            Text(expiry)
                .font(.caption2)
        }
        .padding()
        .background(Color.pink.opacity(0.2))
        .cornerRadius(10)
    }
}

// Preview
struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinView()
    }
}
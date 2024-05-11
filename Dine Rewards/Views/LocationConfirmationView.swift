//
//  LocationConfirmationView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 11/5/24.
//

import SwiftUI
import MapKit

struct LocationConfirmationView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "map")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top)

            Text("Check-in Rewards")
                .font(.title2)
                .bold()

            Text("Let's confirm your location")
                .font(.headline)
                .padding(.top)

            Text("Help us confirm you’re here! By allowing us to use your current location, we can verify your check-ins at the restaurant, making sure you earn your rewards.")
                .padding()
                .multilineTextAlignment(.center)

            Button("Allow Location Access") {
                // Handle location access here
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Consider the actual background color and style based on the screenshot.
        .navigationTitle("Check-in Start")
        .navigationBarItems(trailing: Button("Done") {
            dismiss()
        })
    }
}

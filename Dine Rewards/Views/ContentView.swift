//
//  ContentView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 07/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if isActive {
                ListRestaurantView() // Redirects to the Login View after delay
            } else {
                VStack {
                    Spacer()
                    Image("dineRewardsLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    Text("Loading...")
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Delay before switching views
                withAnimation {
                    isActive = true
                }
            }
        }
        .animation(.easeInOut, value: isActive)
    }
}

#Preview {
    ContentView()
}

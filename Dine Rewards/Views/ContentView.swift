//
//  ContentView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 07/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth: AuthManager = AuthManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                if !auth.isLoggedIn {
                    LoginView() // Redirects to the Login View after delay
                } else {
//                    VStack {
//                        Spacer()
//                        Image("dineRewardsLogo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 200, height: 200)
//                        Text("Loading...")
//                            .foregroundColor(.white)
//                        Spacer()
//                    }
                    if(auth.user != nil && auth.user?.phoneNumber != nil) {
                        ListRestaurantView(phoneNumber: auth.user!.phoneNumber!)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

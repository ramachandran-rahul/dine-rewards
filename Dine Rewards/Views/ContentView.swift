//
//  ContentView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 07/05/24.
//

import SwiftUI
import SVProgressHUD

struct ContentView: View {
    @StateObject var auth: AuthManager = AuthManager.shared
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if isLoading {
                     VStack {
                         Spacer()
                         Image("dineRewardsLogo")
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 200, height: 200)
                             .padding(.bottom, 125)
                         Spacer()
                     }
                     .onAppear {
                         // Customise SVProgressHUD appearance
                         SVProgressHUD.setDefaultStyle(.custom)
                         SVProgressHUD.setBackgroundColor(.clear)
                         SVProgressHUD.setForegroundColor(.white)
                         SVProgressHUD.setRingThickness(7.0)
                         SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 125))
                         SVProgressHUD.show()

                         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                             SVProgressHUD.dismiss()
                             isLoading = false
                         }
                     }
                } else { // Redirects to the relevant view after delay
                    if !auth.isLoggedIn {
                        LoginView()
                    } else {
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
}

#Preview {
    ContentView()
}

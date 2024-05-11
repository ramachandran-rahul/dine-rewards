//
//  LoginView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 10/05/24.
//

import SwiftUI
import iPhoneNumberField

struct LoginView: View {
    @State private var phoneNumber: String = ""
    @State private var processedNumber: String = ""
    @State private var shouldNavigate: Bool = false
    @State private var showError: Bool = false
    
    func onPhoneInputEdit(_: iPhoneNumberField.UIViewType) {
        processedNumber = phoneNumber.replacingOccurrences(of: "[\\s()-]+", with: "", options: .regularExpression)
    }
    
    var body: some View {
        VStack {
            Spacer()
            // Logo
            Circle()
                .fill(Color.red)
                .frame(width: 60, height: 60)
                .overlay(
                    Image("phoneOTP")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                )
                .padding(.top, 20)
            
            // Title and subtitle
            VStack {
                Text("Check-in Rewards")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Join with a Phone Number")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            
            // Explanation text
            Text("If you’ve interacted with any of our restaurant partners using DineRewards, you can use the same phone number again.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            // Phone number entry
            iPhoneNumberField("Phone Number", text: $phoneNumber)
                .flagHidden(false)
                .flagSelectable(true)
                .maximumDigits(10)
                .autofillPrefix(true)
                .formatted()
                .onEdit(perform: onPhoneInputEdit)
                .clearButtonMode(.whileEditing)
                .keyboardType(.numberPad)
                .foregroundColor(.black)
                .padding(.leading, 40)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.red)
                            .padding(.leading, 10)
                        Spacer()
                    }
                )
                .padding(.horizontal)
                .padding(.top, 10)
            
            if showError {
                Text("Invalid phone number")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            // Continue button
            Button(action: {
                // Action for the button
                Auth.shared.startAuth(phoneNumber: processedNumber) { success in
                    DispatchQueue.main.async {
                        if success {
                            shouldNavigate.toggle()
                            //debug
                            print("Api call successful")
                        } else {
                            showError = true
                        }
                    }
                }
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(processedNumber.count < 9 ? Color.gray : Color.red)
                    .cornerRadius(10)
            }
            .disabled(processedNumber.count < 9)
            .padding(.horizontal)
            .padding(.top, 20)
            .background(
                NavigationLink(destination: LoginOTPEntryView(phoneNumber: $phoneNumber), isActive: $shouldNavigate) {
                    EmptyView()
                }
                    .isDetailLink(false) // Prevents opening a new detail view on iPad
            )
            
            Spacer()
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

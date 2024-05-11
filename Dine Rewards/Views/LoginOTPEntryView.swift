//
//  LoginOTPEntryView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 11/05/24.
//

import SwiftUI

struct LoginOTPEntryView: View {
    @State private var phoneNumber: String = ""
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @State private var shouldNavigate: Bool = false
    
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
            Text("If you’ve interacted with any restaurant partners using DineRewards, you can use the same phone number again.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            // Phone number entry
            HStack {
                TextField("Phone Number", text: $phoneNumber)
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
                
                Button(action: {
                    // Action for the button
                    Auth.shared.startAuth(phoneNumber: phoneNumber) { success in
                        guard success else {return}
                        DispatchQueue.main.async {
                            shouldNavigate.toggle()
                            //debug
                            print("Api call successful")
                            
                            // TODO: Separate the phone number and OTP screen.
                            // TODO: Add phone number validation
                            // TODO: Add OTP auto shift to next box and auto clear if unsuccessfull
                        }
                    }
                }) {
                    Text(">")
                        .foregroundColor(.white)
                        .frame(maxWidth: 20)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            
            // OTP entry
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $otp[index])
                    .frame(width: 45, height: 45)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // Continue button
            Button(action: {
                // Action for the button
                Auth.shared.verifyCode(smsCode: otp.joined()){ success in
                    guard success else {return}
                    DispatchQueue.main.async {
                        shouldNavigate.toggle()
                        //debug
                        print("succesfully verified OTP")
                        
                        // TODO: handle what happens once otp verification is successful
                    }
                }
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginOTPEntryView()
}

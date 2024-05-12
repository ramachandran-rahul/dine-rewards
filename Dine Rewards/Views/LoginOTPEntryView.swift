//
//  LoginOTPEntryView.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 11/05/24.
//

import SwiftUI
import iPhoneNumberField

struct LoginOTPEntryView: View {
    @Binding var phoneNumber: String
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @State private var shouldNavigate: Bool = false
    @FocusState private var focusedField: Int?
    
    let otpFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = .init(integerLiteral: 1)
        formatter.maximum = .init(integerLiteral: Int.max)
        formatter.maximumIntegerDigits = 1
        formatter.generatesDecimalNumbers = false
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
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
                
                Text("Verify Your Number")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            
            // Explanation text
            Text("We've sent a One Time Password (OTP) to the number you provided. Please enter it to continue.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            Text("If you haven't received it, tap on \"Resend OTP\".")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            // Phone number field
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.numberPad)
                .foregroundColor(.gray)
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
                .padding(.horizontal, 40)
                .padding(.top, 10)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            // OTP entry
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $otp[index])
                        .frame(width: 45, height: 50)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.title)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .onChange(of: otp[index]) { oldvalue, newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered.count <= 1 {
                                otp[index] = filtered
                            } else {
                                otp[index] = String(filtered.prefix(1))
                            }
                            
                            if newValue.count == 1 && index < 5 {
                                focusedField = index + 1
                            }
                        }
                        .focused($focusedField, equals: index)
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
                        print("succesfully verified OTP")
                    }
                }
            }) {
                Text("Verify & Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(otp.joined().count < 6 ? Color.gray : Color.red)
                    .cornerRadius(10)
            }
            .disabled(otp.joined().count < 6)
            .padding(.horizontal)
            .padding(.top, 20)
            .navigationDestination(isPresented: $shouldNavigate) {
                ListRestaurantView(phoneNumber: phoneNumber)
            }
            
            Spacer()
        }
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

struct LoginOTPEntryView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOTPEntryView(phoneNumber: .constant("9090909090"))
    }
}
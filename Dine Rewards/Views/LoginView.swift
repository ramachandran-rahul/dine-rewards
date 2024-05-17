import Foundation
import SwiftUI
import iPhoneNumberField

/// A view for logging in with a phone number.
struct LoginView: View {
    /// The entered phone number.
    @State private var phoneNumber: String = ""
    /// Indicates whether to navigate to the next view.
    @State private var shouldNavigate: Bool = false
    /// Indicates whether to show an error.
    @State private var showInvalidNumberAlert: Bool = false
    /// The focused state of the field.
    @FocusState private var focusedField: Bool
    
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
            iPhoneNumberField(text: $phoneNumber)
                .flagHidden(false)
                .flagSelectable(true)
                .maximumDigits(10)
                .formatted(false)
                .clearButtonMode(.whileEditing)
                .focused($focusedField)
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
            
            // Continue button
            Button(action: {
                focusedField = false
                AuthManager.shared.startAuth(phoneNumber: phoneNumber) { success in
                    DispatchQueue.main.async {
                        if success {
                            shouldNavigate.toggle()
                            print("API call successful")
                        } else {
                            showInvalidNumberAlert = true
                        }
                    }
                }
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(phoneNumber.count < 9 ? Color.gray : Color.red)
                    .cornerRadius(10)
            }
            .disabled(phoneNumber.count < 9)
            .padding(.horizontal)
            .padding(.top, 20)
            .navigationDestination(isPresented: $shouldNavigate, destination: {
                LoginOTPEntryView(phoneNumber: $phoneNumber)
            })
            Spacer()
        }
        .background(Color.black)
        .navigationBarHidden(true)
        .onAppear{
            focusedField = true
        }
        .onDisappear {
            focusedField = false
        }
        .alert(isPresented: $showInvalidNumberAlert) {
            Alert(
                title: Text("Invalid Phone Number"),
                message: Text("The phone number you entered is invalid. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  CodeRestaurantView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 13/5/24.
//

import SwiftUI

/// A view for entering the restaurant code to register rewards.
struct CodeRestaurantView: View {
    /// The phone number of the user.
    var phoneNumber: String
    /// A closure to call upon completion.
    var onCompletion: () -> Void
    /// The array to store the entered code digits.
    @State private var code: [String] = Array(repeating: "", count: 4)
    /// Indicates whether to show an error alert.
    @State private var showingError = false
    /// The error message to display.
    @State private var errorMessage = ""
    /// The view model for registered restaurants.
    @ObservedObject var viewModel = RegisteredRestaurantViewModel()
    /// The focused field index.
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack {
            Spacer()
            Text("More the cards, more the rewards!")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
                .foregroundStyle(Color.white)
            Text("Please enter the restaurant code near the entrance or ask your lovely waiter for today!")
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $code[index])
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
                        .onChange(of: code[index]) { _, newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered.count <= 1 {
                                code[index] = filtered
                            } else {
                                code[index] = String(filtered.prefix(1))
                            }
                            
                            if newValue.count == 1 && index < 3 {
                                focusedField = index + 1
                            }
                        }
                        .focused($focusedField, equals: index)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Button("Register Your Rewards Card") {
                let fullCode = code.joined()
                viewModel.findAndRegisterRestaurant(phoneNumber: phoneNumber, code: fullCode) { success, message in
                    if success {
                        onCompletion()
                    } else {
                        code = Array(repeating: "", count: 4)
                        showingError = true
                        errorMessage = message
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 20)
            Spacer()
        }
        .background(Color.black)
        .alert(isPresented: $showingError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct CodeRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        CodeRestaurantView(phoneNumber: "+61 4444444444", onCompletion: {})
    }

    static var sampleRestaurant: Restaurant {
        Restaurant(
            id: "1",
            title: "The Best Steakhouse",
            image: "https://i.ibb.co/n3HZnHW/food.jpg",
            lastCheckin: Date(),
            currentCheckins: 1,
            targetCheckins: 3,
            phone: "123-456-7890",
            reward: "Free Meal",
            status: "Active",
            registeredId: "J30aipdXEwOEdUbxhbJq"
        )
    }
}

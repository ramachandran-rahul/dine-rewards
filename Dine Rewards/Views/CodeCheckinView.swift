import SwiftUI

/// A view for entering the check-in code to check in to a restaurant.
struct CodeCheckinView: View {
    /// The restaurant to check in to.
    var restaurant: Restaurant
    /// The phone number of the user.
    var phoneNumber: String
    /// A closure to call upon completion.
    var onCompletion: (Bool) -> Void
    
    /// The array to store the entered code digits.
    @State private var code: [String] = Array(repeating: "", count: 4)
    /// Indicates whether to show an error alert.
    @State private var showingError = false
    /// The error message to display.
    @State private var errorMessage = ""
    
    /// The view model for restaurant-related operations.
    @ObservedObject var viewModel = RestaurantViewModel()
    /// The focused field index.
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack {
            Spacer()
            Text("It's great to have you back!")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
                .foregroundStyle(Color.white)
            Text("Please enter the check-in code on your receipt or ask your lovely waiter for today!")
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
            
            Button("Check-In") {
                let fullCode = code.joined()
                viewModel.checkin(code: fullCode, phoneNumber: phoneNumber, restaurant: restaurant) { success, message, isNavigate in
                    if success {
                        onCompletion(isNavigate)
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

struct CodeCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CodeCheckinView(restaurant: sampleRestaurant, phoneNumber: "+61 4444444444", onCompletion: { isNavigate in
        })
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

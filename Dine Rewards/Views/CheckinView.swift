import SwiftUI

/// A view for checking in to a restaurant.
struct CheckinView: View {
    /// The restaurant to check in to.
    var restaurant: Restaurant
    /// The phone number of the user.
    var phoneNumber: String
    
    /// Indicates whether to show the code entry view for check-in.
    @State private var showCodeCheckin = false
    /// Indicates whether to navigate to the list of restaurants.
    @State private var navigateToList = false
    
    var body: some View {
        VStack (spacing: 0) {
            // Header
            VStack {
                AsyncImage(url: URL(string: restaurant.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .cornerRadius(75)
                .overlay(
                    RoundedRectangle(cornerRadius: 75)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(.bottom)
                Text(restaurant.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 5)
            .padding(.bottom, 20)
            
            Divider()
                .frame(minHeight: 4)
                .overlay(Color.white)
            
            // Milestone rewards
            VStack {
                ScrollView {
                    Text("Grab a Bite.")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .bold()
                        .padding(.bottom, 5)
                    Text("Grab your Rewards!")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .bold()
                        .padding(.bottom)
                    ForEach(0..<restaurant.targetCheckins, id: \.self) { index in
                        ProgressBarView(
                            index: index,
                            current: restaurant.currentCheckins,
                            total: restaurant.targetCheckins
                        )
                    }
                    
                    Text(restaurant.reward + (restaurant.currentCheckins == restaurant.targetCheckins ? " - Unlocked ✅" : ""))
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                Spacer()
                Button("Check-In") {
                    showCodeCheckin = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black)
        }
        .sheet(isPresented: $showCodeCheckin) {
            CodeCheckinView(restaurant: restaurant, phoneNumber: phoneNumber, onCompletion: { isNavigate in
                showCodeCheckin = false
                if (isNavigate) {
                    navigateToList = true
                }
            })
        }
        .background(Color.black)
        .navigationDestination(isPresented: $navigateToList) {
            ListRestaurantView(phoneNumber: phoneNumber)
        }
    }
}

/// A view for displaying progress in a progress bar.
struct ProgressBarView: View {
    /// The index of the progress bar.
    var index: Int
    /// The current progress.
    var current: Int
    /// The total progress.
    var total: Int
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(index < current ? Color.green : Color.gray.opacity(0.5))
                    .frame(width: 10, height: CGFloat(180 / total))
                Text("Check-in: \(index + 1)")
                    .foregroundStyle(Color.white)
                    .bold()
                    .padding(.leading, 20)
            }
        }
    }
}

struct CheckinView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinView(restaurant: sampleRestaurant, phoneNumber: "+61 4444444444")
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

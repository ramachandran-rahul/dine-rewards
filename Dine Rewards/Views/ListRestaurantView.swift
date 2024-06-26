import SwiftUI

/// A view for listing restaurants and rewards.
struct ListRestaurantView: View {
    /// Indicates whether to show the code entry view for adding a restaurant.
    @State private var showCodeRestaurant = false
    /// The view model for managing restaurant data.
    @StateObject var viewModel = RestaurantViewModel()
    /// Indicates whether to show the menu.
    @State var showMenu: Bool = false
    /// Indicates whether to navigate to the login view.
    @State var navigateToLogin = false
    /// The phone number of the user.
    var phoneNumber: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Restaurants")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView {
                    Text("Claim your Rewards")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color.white)
                    ForEach(sortedRestaurants) { restaurant in
                        if restaurant.status == "COMPLETED" {
                            NavigationLink(destination: UseRewardView(restaurant: restaurant, phoneNumber: phoneNumber)) {
                                RestaurantRow(restaurant: restaurant)
                            }
                        }
                    }
                    
                    if containsCompleted && containsOther {
                        Divider()
                    }
                    
                    Text("Check in to unlock these Rewards")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color.white)
                    ForEach(sortedRestaurants) { restaurant in
                        if restaurant.status != "COMPLETED" {
                            NavigationLink(destination: CheckinView(restaurant: restaurant, phoneNumber: phoneNumber)) {
                                RestaurantRow(restaurant: restaurant)
                            }
                        }
                    }
                }
                .padding()
                .onAppear() {
                    viewModel.fetchData(phone: phoneNumber)
                }
                .listStyle(PlainListStyle())
                VStack {
                    Button(action: {
                        self.showCodeRestaurant = true
                    }) {
                        Text("Add a Restaurant")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                    
                    Button(action: {
                        AuthManager.shared.signOut { success in
                            navigateToLogin = success
                        }
                    }) {
                        HStack {
                            Image("logout")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Sign Out")
                                .font(.callout)
                                .foregroundStyle(Color.red)
                                .underline()
                        }
                    }
                    .padding(.bottom)
                    .navigationDestination(isPresented: $navigateToLogin) {
                        LoginView()
                    }
                }
            }
            .background(Color.black)
        }
        .sheet(isPresented: $showCodeRestaurant) {
            CodeRestaurantView(phoneNumber: phoneNumber, onCompletion: {
                showCodeRestaurant = false
            })
        }
        .navigationBarBackButtonHidden()
    }
    
    /// Checks if there are completed rewards.
    var containsCompleted: Bool {
        viewModel.restaurants.contains(where: { $0.status == "COMPLETED" })
    }
    
    /// Checks if there are rewards in progress.
    var containsOther: Bool {
        viewModel.restaurants.contains(where: { $0.status != "COMPLETED" })
    }
    
    /// Sorts the restaurants based on their status.
    var sortedRestaurants: [Restaurant] {
        viewModel.restaurants.sorted { $0.status == "COMPLETED" && $1.status != "COMPLETED" }
    }
    
    /// A view for displaying a restaurant in a row.
    struct RestaurantRow: View {
        /// The restaurant to display.
        var restaurant: Restaurant
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2) // White border with rounded corners
                    )
                HStack {
                    AsyncImage(url: URL(string: restaurant.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 75, height: 75)
                    .cornerRadius(8)
                    .padding(.trailing, 5)
                    
                    VStack(alignment: .leading) {
                        Text(restaurant.title)
                            .font(.title3)
                        Text("Reward: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.reward)")
                            .font(.subheadline)
                        Text("Progress: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.currentCheckins)/\(restaurant.targetCheckins)")
                            .font(.subheadline)
                        Text("Status: ")
                            .font(.subheadline)
                            .bold() +
                        Text("\(restaurant.status == "COMPLETED" ? "Reward Available" : "In Progress")")
                            .font(.subheadline)
                    }
                    .foregroundStyle(Color.white)
                    Spacer()
                    Image(systemName: restaurant.status == "COMPLETED" ? "checkmark.circle" : "chevron.right")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .padding(.vertical, 5)
        }
    }
}

struct ListRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        ListRestaurantView(phoneNumber: "+61 4444444444")
    }
}

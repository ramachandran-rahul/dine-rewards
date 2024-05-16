import SwiftUI
import FirebaseCore
import FirebaseAuth

// MARK: - AppDelegate

/// The app delegate class for handling Firebase setup and lifecycle events.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Handles the application's didFinishLaunchingWithOptions lifecycle event.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        return true
    }
    
    /// Handles the registration for remote notifications with device token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        FirebaseAuth.Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    /// Handles the reception of remote notifications.
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if FirebaseAuth.Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    /// Handles the opening of URLs by the application.
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("\(#function)")
        if FirebaseAuth.Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}

// MARK: - App

@main
struct Dine_RewardsApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = RestaurantViewModel()
    
    init() {
        // Customize the appearance of the navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        
        // Customize the back button appearance
        appearance.setBackIndicatorImage(
            UIImage(systemName: "arrowshape.turn.up.left.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal),
            transitionMaskImage: UIImage(systemName: "arrowshape.turn.up.left.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        )
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.red]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("Received URL: \(url)")
                    FirebaseAuth.Auth.auth().canHandle(url) // <- just for information purposes
                }
                .environmentObject(viewModel)
        }
    }
}

//
//  Dine_RewardsApp.swift
//  Dine Rewards
//
//  Created by Rahul Ramachandran on 07/05/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        FirebaseAuth.Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if FirebaseAuth.Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("\(#function)")
        if FirebaseAuth.Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}

@main
struct Dine_RewardsApp: App {
    // register app delegate for firebase setup
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

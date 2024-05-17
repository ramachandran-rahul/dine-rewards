import Foundation
import SwiftUI
import FirebaseAuth

/// AuthManager is a singleton class that manages user authentication using Firebase.
class AuthManager: ObservableObject {
    /// Key used to store the verification ID in UserDefaults.
    private var verificationIdKey: String = "verificationId"
    /// Shared instance of AuthManager.
    static let shared = AuthManager()
    /// Published property to track the login status of the user.
    @Published var isLoggedIn: Bool = false
    /// Published property to store the current user's information.
    @Published var user: User?
    /// Firebase authentication instance.
    private let auth = FirebaseAuth.Auth.auth()
    
    /// Private initializer to enforce singleton pattern.
    private init() {
        // Adding state change listener to update login status and user information.
        auth.addStateDidChangeListener { auth, user in
            self.isLoggedIn = user != nil
            self.user = user
        }
    }
    
    /// Verification ID received after sending the OTP.
    private var verificationId: String?
    
    /// Starts the authentication process by sending an OTP to the given phone number.
    /// - Parameters:
    ///   - phoneNumber: The phone number to which the OTP should be sent.
    ///   - completion: Completion handler with a boolean indicating success or failure.
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            // Storing the verification ID and saving it to UserDefaults.
            self.verificationId = verificationId
            UserDefaults.standard.set(self.verificationId, forKey: self.verificationIdKey)
            completion(true)
        }
    }
    
    /// Verifies the OTP code and signs in the user.
    /// - Parameters:
    ///   - smsCode: The OTP code received by the user.
    ///   - completion: Completion handler with a boolean indicating success or failure.
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        // Retrieve the verification ID from UserDefaults if it's not already set.
        if self.verificationId == nil {
            self.verificationId = UserDefaults.standard.string(forKey: verificationIdKey)
        }
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        // Create a credential using the verification ID and OTP code.
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        // Sign in the user with the credential.
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            // Update the user property and indicate success.
            self.user = result?.user
            completion(true)
        }
    }
    
    /// Signs out the current user.
    /// - Parameter completion: Completion handler with a boolean indicating success or failure.
    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            self.user = nil
            completion(true)
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
            completion(false)
        }
    }
}

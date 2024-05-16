//
//  auth.swift
//  Dine Rewards
//
//  Created by Riyan Pahuja on 10/5/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthManager: ObservableObject {
    //single shared instance
    private var verificationIdKey: String = "verficationId"
    static let shared = AuthManager()
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    private let auth = FirebaseAuth.Auth.auth()
    
    init() {
        auth.addStateDidChangeListener { auth, user in
            self.isLoggedIn = user != nil
            self.user = user
        }
    }
    
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, resendOtp: Bool = false, completion: @escaping (Bool) -> Void) {
        if(!resendOtp){
            if let savedValue = UserDefaults.standard.string(forKey: verificationIdKey) {
                self.verificationId = savedValue
                completion(true)
                return
            }
        }
    
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            guard let verficationId = verificationId, error == nil else {
                return
            }
            
            self.verificationId = verficationId
            UserDefaults.standard.set(self.verificationId, forKey: self.verificationIdKey)
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
            self.user = result?.user
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
            do {
                try Auth.auth().signOut()
                self.user = nil
                completion(true)
            } catch let signOutError as NSError {
                print(signOutError.localizedDescription)
            }
        }
}

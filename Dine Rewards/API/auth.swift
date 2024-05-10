//
//  auth.swift
//  Dine Rewards
//
//  Created by Riyan Pahuja on 10/5/2024.
//

import Foundation
import FirebaseAuth

class Auth {
    //single shared instance
    static let shared = Auth()
    
    private let auth = FirebaseAuth.Auth.auth()
    
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            guard let verficationId = verificationId, error == nil else {
                return
            }
            
            self.verificationId = verficationId
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
        }
    }
}

//
//  AuthManager.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//
//
//import SwiftUI
//import LocalAuthentication
//import Combine
//

import Foundation
import LocalAuthentication
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false // Add this

    init() {}

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }

            self?.fetchUserData(uid: user.uid) { result in
                switch result {
                case .success(let userData):
                    DispatchQueue.main.async {
                        self?.currentUser = userData
                        self?.isAuthenticated = true
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchUserData(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "FirebaseFirestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found."])))
                return
            }
            
            let user = User(id: uid, email: data["email"] as? String ?? "")
            completion(.success(user))
        }
    }

    func authenticateWithBiometrics(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in with biometrics") { success, authError in
                if success {
                    completion(true, nil)
                } else {
                    completion(false, authError?.localizedDescription)
                }
            }
        } else {
            completion(false, "Biometric authentication not available")
        }
    }

    enum AuthError: LocalizedError {
        case invalidCredentials

        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Invalid email or password"
            }
        }
    }
}


//    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        // Simulated delay
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            if email == "demo@user.com" && password == "password" {
//                let user = User(id: UUID(), email: email)
//                DispatchQueue.main.async {
//                    self.currentUser = user
//                    completion(.success(user))
//                }
//            } else {
//                completion(.failure(AuthError.invalidCredentials))
//            }
//        }
//    }

 

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
///// Manages user authentication state throughout the app
//class AuthManager: ObservableObject {
//    // MARK: - Published Properties
//    
//    /// Indicates if a user is currently authenticated
//    @Published var isAuthenticated = false
//    
//    /// Current user information
//    @Published var currentUser: User?
//    
//    /// Authentication state
//    @Published var authState: AuthState = .notAuthenticated
//    
//    // MARK: - Private Properties
//    
//    /// Cancellables for managing subscriptions
//    private var cancellables = Set<AnyCancellable>()
//    
//    /// User defaults for persistent auth state
//    private let userDefaults = UserDefaults.standard
//    
//    // MARK: - Initialization
//    
//    init() {
//        // Check for saved authentication state
//        checkSavedAuthState()
//    }
//    
//    // MARK: - Public Methods
//    
//    /// Signs in a user with email and password
//    /// - Parameters:
//    ///   - email: User's email address
//    ///   - password: User's password
//    ///   - completion: Completion handler with result
//    func signIn(email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
//        // Set loading state
//        authState = .loading
//        
//        // Simulate network request
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            // For demo purposes, accept any well-formed email/password
//            if email.contains("@") && email.contains(".") && password.count >= 6 {
//                // Create user object
//                let user = User(
//                    id: UUID().uuidString,
//                    email: email,
//                    name: email.components(separatedBy: "@").first ?? "User",
//                    profileImage: nil
//                )
//                
//                // Update authentication state
//                self.currentUser = user
//                self.isAuthenticated = true
//                self.authState = .authenticated
//                
//                // Save authentication state
//                self.saveAuthState()
//                
//                completion(.success(user))
//            } else {
//                self.authState = .error(message: "Invalid credentials")
//                completion(.failure(.invalidCredentials))
//            }
//        }
//    }
//    
//    /// Signs out the current user
//    func signOut() {
//        currentUser = nil
//        isAuthenticated = false
//        authState = .notAuthenticated
//        
//        // Clear saved auth state
//        userDefaults.removeObject(forKey: "authUser")
//        userDefaults.removeObject(forKey: "isAuthenticated")
//    }
//    
//    /// Authenticates user with biometrics (Face ID or Touch ID)
//    /// - Parameter completion: Completion handler with result
//    func authenticateWithBiometrics(completion: @escaping (Result<Void, AuthError>) -> Void) {
//        let context = LAContext()
//        var error: NSError?
//        
//        // Check if biometric authentication is available
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            authState = .loading
//            
//            context.evaluatePolicy(
//                .deviceOwnerAuthenticationWithBiometrics,
//                localizedReason: "Log in to Sri Lankan Heritage & Wildlife Explorer"
//            ) { success, error in
//                DispatchQueue.main.async {
//                    if success {
//                        // Create demo user if no user exists
//                        if self.currentUser == nil {
//                            self.currentUser = User(
//                                id: UUID().uuidString,
//                                email: "demo@example.com",
//                                name: "Demo User",
//                                profileImage: nil
//                            )
//                        }
//                        
//                        self.isAuthenticated = true
//                        self.authState = .authenticated
//                        self.saveAuthState()
//                        completion(.success(()))
//                    } else {
//                        self.authState = .error(message: error?.localizedDescription ?? "Biometric authentication failed")
//                        completion(.failure(.biometricFailed))
//                    }
//                }
//            }
//        } else {
//            authState = .error(message: "Biometric authentication not available")
//            completion(.failure(.biometricNotAvailable))
//        }
//    }
//    
//    /// Sign in with Apple
//    func signInWithApple(completion: @escaping (Result<User, AuthError>) -> Void) {
//        // Actual implementation would integrate with Apple Sign In
//        authState = .loading
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let user = User(
//                id: UUID().uuidString,
//                email: "apple_user@example.com",
//                name: "Apple User",
//                profileImage: nil
//            )
//            
//            self.currentUser = user
//            self.isAuthenticated = true
//            self.authState = .authenticated
//            self.saveAuthState()
//            
//            completion(.success(user))
//        }
//    }
//    
//    /// Register a new user
//    /// - Parameters:
//    ///   - email: User's email
//    ///   - password: User's password
//    ///   - name: User's name
//    ///   - completion: Completion handler with result
//    func register(email: String, password: String, name: String, completion: @escaping (Result<User, AuthError>) -> Void) {
//        authState = .loading
//        
//        // Validate inputs
//        guard email.contains("@"), email.contains(".") else {
//            authState = .error(message: "Invalid email format")
//            completion(.failure(.invalidEmail))
//            return
//        }
//        
//        guard password.count >= 6 else {
//            authState = .error(message: "Password must be at least 6 characters")
//            completion(.failure(.weakPassword))
//            return
//        }
//        
//        // Simulate network request
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            let user = User(
//                id: UUID().uuidString,
//                email: email,
//                name: name,
//                profileImage: nil
//            )
//            
//            self.currentUser = user
//            self.isAuthenticated = true
//            self.authState = .authenticated
//            self.saveAuthState()
//            
//            completion(.success(user))
//        }
//    }
//    
//    /// Request password reset
//    /// - Parameter email: User's email
//    /// - Parameter completion: Completion handler with result
//    func resetPassword(email: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
//        guard email.contains("@"), email.contains(".") else {
//            completion(.failure(.invalidEmail))
//            return
//        }
//        
//        // Simulate network request
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            // In a real app, this would send a password reset email
//            completion(.success(()))
//        }
//    }
//    
//    // MARK: - Private Methods
//    
//    /// Saves the current authentication state to UserDefaults
//    private func saveAuthState() {
//        if let user = currentUser, let userData = try? JSONEncoder().encode(user) {
//            userDefaults.set(userData, forKey: "authUser")
//        }
//        userDefaults.set(isAuthenticated, forKey: "isAuthenticated")
//    }
//    
//    /// Checks for saved authentication state in UserDefaults
//    private func checkSavedAuthState() {
//        isAuthenticated = userDefaults.bool(forKey: "isAuthenticated")
//        
//        if isAuthenticated, let userData = userDefaults.data(forKey: "authUser") {
//            currentUser = try? JSONDecoder().decode(User.self, from: userData)
//            
//            if currentUser != nil {
//                authState = .authenticated
//            } else {
//                // User data corrupted
//                isAuthenticated = false
//                authState = .notAuthenticated
//            }
//        }
//    }
//}
//
//// MARK: - Supporting Types
//
///// Represents a user in the app
//struct User: Codable, Identifiable {
//    let id: String
//    let email: String
//    let name: String
//    let profileImage: String?
//    
//    var initials: String {
//        let components = name.components(separatedBy: " ")
//        if components.count > 1, let first = components.first?.first, let last = components.last?.first {
//            return "\(first)\(last)"
//        } else if let first = name.first {
//            return String(first)
//        }
//        return "U"
//    }
//}
//
///// Represents authentication states
//enum AuthState: Equatable {
//    case notAuthenticated
//    case authenticated
//    case loading
//    case error(message: String)
//    
//    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
//        switch (lhs, rhs) {
//        case (.notAuthenticated, .notAuthenticated):
//            return true
//        case (.authenticated, .authenticated):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.error(let lhsMessage), .error(let rhsMessage)):
//            return lhsMessage == rhsMessage
//        default:
//            return false
//        }
//    }
//}
//
///// Authentication error types
//enum AuthError: Error {
//    case invalidCredentials
//    case networkError
//    case biometricFailed
//    case biometricNotAvailable
//    case invalidEmail
//    case weakPassword
//    case userNotFound
//    case unknown
//    
//    var localizedDescription: String {
//        switch self {
//        case .invalidCredentials:
//            return "Invalid email or password"
//        case .networkError:
//            return "Network error. Please check your connection"
//        case .biometricFailed:
//            return "Biometric authentication failed"
//        case .biometricNotAvailable:
//            return "Biometric authentication not available on this device"
//        case .invalidEmail:
//            return "Please enter a valid email address"
//        case .weakPassword:
//            return "Password must be at least 6 characters"
//        case .userNotFound:
//            return "User not found"
//        case .unknown:
//            return "An unknown error occurred"
//        }
//    }
//}
import Foundation
import LocalAuthentication
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    //var isAuthenticated :Bool = false
    

    @Published var currentUser: User?

    init() {}

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
                        self?.authState = .authenticated
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
            
            let user = User(uid: uid, data: data)
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

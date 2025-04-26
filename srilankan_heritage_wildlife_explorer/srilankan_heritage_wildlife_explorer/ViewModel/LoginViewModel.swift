////
////  Untitled.swift
////  test
////
////  Created by Janusha 023 on 2025-04-24.
////
//

import SwiftUI
import LocalAuthentication
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var navigateToHome = false
    @Published var loginSuccess = false
    
    private var authManager: AuthManager
    
    init(authManager: AuthManager = AuthManager.shared) {
        self.authManager = authManager
    }
    
    var biometricType: LABiometryType {
        let context = LAContext()
        var error: NSError?
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return context.biometryType
    }
    
    func validateInputs() -> Bool {
        if email.isEmpty {
            showAlert("Please enter your email")
            return false
        }
        if !email.contains("@") || !email.contains(".") {
            showAlert("Please enter a valid email")
            return false
        }
        if password.isEmpty {
            showAlert("Please enter your password")
            return false
        }
        if password.count < 6 {
            showAlert("Password must be at least 6 characters")
            return false
        }
        return true
    }

    func login() {
        guard validateInputs() else { return }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.alertMessage = "Login failed: \(error.localizedDescription)"
                    self.showingAlert = true
                    return
                }
                
                guard let user = result?.user else {
                    self.alertMessage = "User data not found."
                    self.showingAlert = true
                    return
                }
                
                // ✅ Successful login
                print("Logged in user: \(user.uid), email: \(user.email ?? "N/A")")
                self.loginSuccess = true
                self.navigateToHome = true
            }
        }
    }

    func authenticateWithBiometrics() {
        authManager.authenticateWithBiometrics { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.navigateToHome = true
                } else {
                    self?.showAlert(message ?? "Biometric authentication failed")
                }
            }
        }
    }

    func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

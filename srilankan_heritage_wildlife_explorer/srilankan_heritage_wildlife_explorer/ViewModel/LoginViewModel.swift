//
//  Untitled.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import SwiftUI
import LocalAuthentication

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var navigateToHome = false
    
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
        authManager.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.navigateToHome = true
                case .failure(let error):
                    self?.showAlert(error.localizedDescription)
                }
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

//
//  LoginScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-09.
//
import SwiftUI
import LocalAuthentication

/// A view that handles user authentication
struct LoginScreen: View {
    // MARK: - Properties
    
    /// Environment object for authentication state
    @EnvironmentObject var authManager: AuthManager
    
    /// Controls text field input
    @State private var email = ""
    @State private var password = ""
    
    /// UI state
    @State private var isPasswordVisible = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    /// Controls navigation to the home screen
    @State private var navigateToHome = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack(spacing: 20) {
                headerView
                
                Spacer().frame(height: 20)
                
                loginForm
                
                biometricButton
                
                Spacer().frame(height: 20)
                
                divider
                
                socialLoginButtons
                
                registerLink
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
            
            // Loading overlay
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    )
            }
            
            // Hidden navigation link
            NavigationLink(
                destination: HomeScreen().navigationBarHidden(true),
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Authentication"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - UI Components
    
    /// Header section with logo and welcome text
    private var headerView: some View {
        VStack(spacing: 15) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Sign in to continue your exploration")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    /// Form with email and password fields
    private var loginForm: some View {
        VStack(spacing: 15) {
            // Email field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            // Password field with visibility toggle
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Forgot password link
            HStack {
                Spacer()
                Button(action: handleForgotPassword) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            .padding(.top, 5)
            
            // Login button
            Button(action: handleLogin) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
    }
    
    /// Biometric authentication button (Face ID/Touch ID)
    private var biometricButton: some View {
        Button(action: authenticateWithBiometrics) {
            HStack {
                Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                Text("Login with \(LAContext().biometryType == .faceID ? "Face ID" : "Touch ID")")
            }
            .font(.headline)
            .foregroundColor(Color("PrimaryColor"))
        }
    }
    
    /// Divider line with "or continue with" text
    private var divider: some View {
        HStack {
            VStack {
                Divider()
            }
            
            Text("or continue with")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
            
            VStack {
                Divider()
            }
        }
    }
    
    /// Social login buttons
    private var socialLoginButtons: some View {
        HStack(spacing: 20) {
            socialLoginButton(imageName: "apple.logo", action: handleAppleLogin)
            socialLoginButton(imageName: "g.circle.fill", action: handleGoogleLogin)
            socialLoginButton(imageName: "f.circle.fill", action: handleFacebookLogin)
        }
        .padding(.vertical, 10)
    }
    
    /// Individual social login button
    private func socialLoginButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
    }
    
    /// Link to registration screen
    private var registerLink: some View {
        HStack(spacing: 5) {
            Text("Don't have an account?")
                .foregroundColor(.secondary)
            
            Button(action: navigateToRegistration) {
                Text("Register")
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
        .padding(.top, 10)
    }
    
    // MARK: - Functions
    
    /// Handles traditional email/password login
    private func handleLogin() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            // Here you would normally verify credentials with a service
            navigateToHome = true
        }
    }
    
    /// Validates user input for email and password
    private func validateInputs() -> Bool {
        // Simple validation
        if email.isEmpty {
            showAlert(message: "Please enter your email")
            return false
        }
        
        if !email.contains("@") || !email.contains(".") {
            showAlert(message: "Please enter a valid email")
            return false
        }
        
        if password.isEmpty {
            showAlert(message: "Please enter your password")
            return false
        }
        
        if password.count < 6 {
            showAlert(message: "Password must be at least 6 characters")
            return false
        }
        
        return true
    }
    
    /// Shows an alert with a specified message
    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    /// Handles biometric authentication
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        navigateToHome = true
                    } else {
                        // Authentication failed
                        if let error = error {
                            showAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
        } else {
            // Biometric authentication not available
            showAlert(message: "Biometric authentication not available")
        }
    }
    
    /// Handles forgot password action
    private func handleForgotPassword() {
        showAlert(message: "Password reset link sent to your email")
    }
    
    /// Handles Apple login
    private func handleAppleLogin() {
        // Implementation for Apple Sign In would go here
        showAlert(message: "Apple login not implemented in this demo")
    }
    
    /// Handles Google login
    private func handleGoogleLogin() {
        // Implementation for Google Sign In would go here
        showAlert(message: "Google login not implemented in this demo")
    }
    
    /// Handles Facebook login
    private func handleFacebookLogin() {
        // Implementation for Facebook Sign In would go here
        showAlert(message: "Facebook login not implemented in this demo")
    }
    
    /// Navigates to registration screen
    private func navigateToRegistration() {
        // Implementation would navigate to registration screen
        showAlert(message: "Registration not implemented in this demo")
    }
}

// MARK: - Preview

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(AuthManager())
    }
}

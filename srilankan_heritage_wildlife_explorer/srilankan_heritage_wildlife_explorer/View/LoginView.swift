////
////  LoginView.swift
////  srilankan_heritage_wildlife_explorer
////
////  Created by Janusha 023 on 2025-04-09.
////
//
//import SwiftUI
//import LocalAuthentication
//
//struct LoginView: View {
//    @EnvironmentObject var authManager: AuthManager
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var isPasswordVisible = false
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @State private var isLoading = false
//    @State private var navigateToHome = false
//
//    private var biometricType: LABiometryType {
//        let context = LAContext()
//        var error: NSError?
//        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
//        return context.biometryType
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color("BackgroundColor").ignoresSafeArea()
//                
//                VStack(spacing: 20) {
//                    headerView
//                    
//                    Spacer().frame(height: 20)
//                    
//                    loginForm
//                    
//                    if biometricType != .none {
//                        biometricButton
//                    }
//
//                    Spacer().frame(height: 20)
//                    
//                    divider
//                    
//                    socialLoginButtons
//                    
//                    registerLink
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 30)
//                .padding(.top, 50)
//                
//                if isLoading {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .overlay(
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                                .scaleEffect(1.5)
//                        )
//                }
//
//                NavigationLink(
//                    destination: Text("🏠 Home Screen").navigationBarHidden(true),
//                    isActive: $navigateToHome,
//                    label: { EmptyView() }
//                )
//            }
//            .navigationBarHidden(true)
//            .alert(isPresented: $showingAlert) {
//                Alert(
//                    title: Text("Authentication"),
//                    message: Text(alertMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//
//    private var headerView: some View {
//        VStack(spacing: 15) {
//            Image("AppLogo")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//            
//            Text("Welcome Back")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            
//            Text("Sign in to continue your exploration")
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//        }
//    }
//
//    private var loginForm: some View {
//        VStack(spacing: 15) {
//            TextField("Email", text: $email)
//                .keyboardType(.emailAddress)
//                .autocapitalization(.none)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            
//            HStack {
//                Group {
//                    if isPasswordVisible {
//                        TextField("Password", text: $password)
//                    } else {
//                        SecureField("Password", text: $password)
//                    }
//                }
//                .autocapitalization(.none)
//
//                Button(action: {
//                    isPasswordVisible.toggle()
//                }) {
//                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            .background(Color(.systemGray6))
//            .cornerRadius(8)
//            
//            HStack {
//                Spacer()
//                Button(action: handleForgotPassword) {
//                    Text("Forgot Password?")
//                        .font(.subheadline)
//                        .foregroundColor(Color("PrimaryGreen"))
//                }
//            }
//            .padding(.top, 5)
//            
//            Button(action: handleLogin) {
//                Text("Log In")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 15)
//                    .background(Color("PrimaryGreen"))
//                    .cornerRadius(8)
//            }
//            .padding(.top, 20)
//        }
//    }
//
//    private var biometricButton: some View {
//        Button(action: authenticateWithBiometrics) {
//            HStack {
//                Image(systemName: biometricType == .faceID ? "faceid" : "touchid")
//                Text("Login with \(biometricType == .faceID ? "Face ID" : "Touch ID")")
//            }
//            .font(.headline)
//            .foregroundColor(Color("PrimaryGreen"))
//        }
//    }
//
//    private var divider: some View {
//        HStack {
//            Divider().frame(height: 1).background(Color.secondary)
//            Text("or continue with")
//                .font(.footnote)
//                .foregroundColor(.secondary)
//                .padding(.horizontal, 10)
//            Divider().frame(height: 1).background(Color.secondary)
//        }
//    }
//
//    private var socialLoginButtons: some View {
//        HStack(spacing: 20) {
//            socialLoginButton(imageName: "apple.logo", action: handleAppleLogin)
//            socialLoginButton(imageName: "g.circle.fill", action: handleGoogleLogin)
//            socialLoginButton(imageName: "f.circle.fill", action: handleFacebookLogin)
//        }
//        .padding(.vertical, 10)
//    }
//
//    private func socialLoginButton(imageName: String, action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Image(systemName: imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 24, height: 24)
//                .padding()
//                .background(Color(.systemGray6))
//                .clipShape(Circle())
//        }
//    }
//
//    private var registerLink: some View {
//        HStack(spacing: 5) {
//            Text("Don't have an account?")
//                .foregroundColor(.secondary)
//            
//            Button(action: navigateToRegistration) {
//                Text("Register")
//                    .fontWeight(.bold)
//                    .foregroundColor(Color("PrimaryGreen"))
//            }
//        }
//        .padding(.top, 10)
//    }
//
//    // MARK: - Functional Logic
//
//    private func handleLogin() {
//        guard validateInputs() else { return }
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            isLoading = false
//            navigateToHome = true
//        }
//    }
//
//    private func validateInputs() -> Bool {
//        if email.isEmpty {
//            showAlert(message: "Please enter your email")
//            return false
//        }
//        if !email.contains("@") || !email.contains(".") {
//            showAlert(message: "Please enter a valid email")
//            return false
//        }
//        if password.isEmpty {
//            showAlert(message: "Please enter your password")
//            return false
//        }
//        if password.count < 6 {
//            showAlert(message: "Password must be at least 6 characters")
//            return false
//        }
//        return true
//    }
//
//    private func showAlert(message: String) {
//        alertMessage = message
//        showingAlert = true
//    }
//
//    private func authenticateWithBiometrics() {
//        let context = LAContext()
//        var error: NSError?
//
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to your account") { success, authError in
//                DispatchQueue.main.async {
//                    if success {
//                        navigateToHome = true
//                    } else {
//                        showAlert(message: authError?.localizedDescription ?? "Failed to authenticate")
//                    }
//                }
//            }
//        } else {
//            showAlert(message: "Biometric authentication not available")
//        }
//    }
//
//    private func handleForgotPassword() {
//        showAlert(message: "Password reset link sent to your email")
//    }
//
//    private func handleAppleLogin() {
//        showAlert(message: "Apple login not implemented in this demo")
//    }
//
//    private func handleGoogleLogin() {
//        showAlert(message: "Google login not implemented in this demo")
//    }
//
//    private func handleFacebookLogin() {
//        showAlert(message: "Facebook login not implemented in this demo")
//    }
//
//    private func navigateToRegistration() {
//        showAlert(message: "Registration not implemented in this demo")
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView().environmentObject(AuthManager())
//    }
//}


//
//  LoginView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-09.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    @State private var isLoading = false
    @State private var navigateToHome = false
    @State private var navigateToRegister = false

    private var biometricType: LABiometryType {
        let context = LAContext()
        var error: NSError?
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return context.biometryType
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    
                    Spacer().frame(height: 20)
                    
                    loginForm
                    
                    if biometricType != .none {
                        biometricButton
                    }

                    Spacer().frame(height: 20)
                    
                    divider
                    
                    socialLoginButtons
                    
                    registerLink
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        )
                }

                NavigationLink(
                    destination: Text("🏠 Home Screen").navigationBarHidden(true),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
                NavigationLink(
                    destination: RegisterView().navigationBarHidden(true),
                    isActive: $navigateToRegister,
                    label: { EmptyView() }
                )

            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("Authentication"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

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

    private var loginForm: some View {
        VStack(spacing: 15) {
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            HStack {
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .autocapitalization(.none)

                Button(action: {
                    viewModel.isPasswordVisible.toggle()
                }) {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            HStack {
                Spacer()
                Button(action: handleForgotPassword) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryGreen"))
                }
            }
            .padding(.top, 5)
            
            Button(action: handleLogin) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("PrimaryGreen"))
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
    }

    private var biometricButton: some View {
        Button(action: authenticateWithBiometrics) {
            HStack {
                Image(systemName: biometricType == .faceID ? "faceid" : "touchid")
                Text("Login with \(biometricType == .faceID ? "Face ID" : "Touch ID")")
            }
            .font(.headline)
            .foregroundColor(Color("PrimaryGreen"))
        }
    }

    private var divider: some View {
        HStack {
            Divider().frame(height: 1).background(Color.secondary)
            Text("or continue with")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
            Divider().frame(height: 1).background(Color.secondary)
        }
    }

    private var socialLoginButtons: some View {
        HStack(spacing: 20) {
            socialLoginButton(imageName: "apple.logo", action: handleAppleLogin)
            socialLoginButton(imageName: "g.circle.fill", action: handleGoogleLogin)
            socialLoginButton(imageName: "f.circle.fill", action: handleFacebookLogin)
        }
        .padding(.vertical, 10)
    }

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

    private var registerLink: some View {
        HStack(spacing: 5) {
            Text("Don't have an account?")
                .foregroundColor(.secondary)
            
            Button(action: navigateToRegistration) {
                Text("Register")
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryGreen"))
            }
        }
        .padding(.top, 10)
    }

    // MARK: - Functional Logic

    private func handleLogin() {
        viewModel.login()
    }

    private func handleForgotPassword() {
        showAlert(message: "Password reset link sent to your email")
    }

    private func authenticateWithBiometrics() {
        viewModel.authenticateWithBiometrics()
    }

    private func handleAppleLogin() {
        showAlert(message: "Apple login not implemented in this demo")
    }

    private func handleGoogleLogin() {
        showAlert(message: "Google login not implemented in this demo")
    }

    private func handleFacebookLogin() {
        showAlert(message: "Facebook login not implemented in this demo")
    }

//    private func navigateToRegistration() {
//        showAlert(message: "Registration not implemented in this demo")
//    }
    private func navigateToRegistration() {
        navigateToRegister = true
    }



    private func showAlert(message: String) {
        viewModel.alertMessage = message
        viewModel.showingAlert = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthManager())
    }
}


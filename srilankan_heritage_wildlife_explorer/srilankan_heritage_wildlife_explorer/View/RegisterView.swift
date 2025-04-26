//
//  RegisterView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false

    @State private var isLoading: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()

                VStack(spacing: 20) {
                    header
                    formFields
                    registerButton
                    Spacer()
                    loginLink
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
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Registration"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private var header: some View {
        VStack(spacing: 15) {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Join us and explore the journey")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var formFields: some View {
        VStack(spacing: 15) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .autocapitalization(.none)

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

            HStack {
                Group {
                    if isConfirmPasswordVisible {
                        TextField("Confirm Password", text: $confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                }
                .autocapitalization(.none)

                Button(action: {
                    isConfirmPasswordVisible.toggle()
                }) {
                    Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }

    private var registerButton: some View {
        Button(action: handleRegister) {
            Text("Register")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(Color("PrimaryGreen"))
                .cornerRadius(8)
        }
        .padding(.top, 20)
    }

    private var loginLink: some View {
        HStack(spacing: 5) {
            Text("Already have an account?")
                .foregroundColor(.secondary)

            NavigationLink(destination: LoginView()) {
                Text("Log In")
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryGreen"))
            }
        }
        .padding(.top, 10)
    }

    private func handleRegister() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error {
                showAlert(message: error.localizedDescription)
                return
            }

            showAlert(message: "Account created successfully! 🎉")
            // Optional: Navigate to another screen or clear fields
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

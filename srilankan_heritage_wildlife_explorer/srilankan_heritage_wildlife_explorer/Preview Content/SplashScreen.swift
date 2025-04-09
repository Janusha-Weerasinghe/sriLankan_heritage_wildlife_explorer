//
//  SplashScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-09.
//


import SwiftUI

/// A view that displays the application's splash screen with animation
struct SplashScreen: View {
// MARK: - Properties
/// Controls navigation to the next screen
@State private var isActive = false

/// Animation properties
@State private var opacity = 0.0
@State private var scale: CGFloat = 0.8

// MARK: - Body
var body: some View {
if isActive {
// Ensure OnboardingScreen is defined elsewhere in your project
OnboardingScreen()
} else {
splashScreenContent
}
}

// MARK: - UI Components
/// The main content of the splash screen
private var splashScreenContent: some View {
ZStack {
// Background color that fills the entire screen
Color("PrimaryGreen").ignoresSafeArea()

// Logo and text stack
VStack(spacing: 20) {
appLogo
appTitle
appTagline
}
.scaleEffect(scale)
.opacity(opacity)
.onAppear(perform: animateSplashScreen)
}
}

/// The application logo
private var appLogo: some View {
Image("AppLogo")
.resizable()
.aspectRatio(contentMode: .fit)
.frame(width: 150, height: 150)
.accessibilityLabel("App logo")
}

/// The application title
private var appTitle: some View {
Text("AR Heritage & Wildlife Explorer")
.font(.title) // Dynamically adjust for text size
.fontWeight(.bold)
.foregroundColor(.white)
.multilineTextAlignment(.center)
.padding(.horizontal)
.accessibilityLabel("AR Heritage & Wildlife Explorer")
}

/// The application tagline
private var appTagline: some View {
Text("Discover Sri Lanka's culture & wildlife")
.font(.headline)
.foregroundColor(.white.opacity(0.8))
.accessibilityLabel("Discover Sri Lanka's culture and wildlife")
}

// MARK: - Functions
/// Animates the splash screen components and handles navigation timing
private func animateSplashScreen() {
// Animate the appearance of the splash screen elements
withAnimation(.easeIn(duration: 1.0)) {
self.opacity = 1.0
self.scale = 1.0
}

// Transition to onboarding after delay (shortened to 2 seconds)
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
withAnimation {
self.isActive = true
}
}
}
}

// MARK: - Preview
struct SplashScreen_Previews: PreviewProvider {
static var previews: some View {
SplashScreen()
}
}

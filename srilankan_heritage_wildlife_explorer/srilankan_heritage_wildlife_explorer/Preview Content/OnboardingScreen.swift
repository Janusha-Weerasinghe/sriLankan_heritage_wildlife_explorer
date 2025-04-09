//
//  OnboardingScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-09.
//
import SwiftUI

/// Data model representing a single onboarding screen item
struct OnboardingItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

/// A view that displays the onboarding screens with pagination
struct OnboardingScreen: View {
    // MARK: - Properties
    @State private var currentPage = 0
    @State private var navigateToLogin = false

    private let onboardingItems = [
        OnboardingItem(
            image: "onboarding1",
            title: "Explore Heritage Sites",
            description: "Discover Sri Lanka's rich cultural heritage through interactive AR experiences"
        ),
        OnboardingItem(
            image: "onboarding2",
            title: "Discover Wildlife",
            description: "Encounter native wildlife through realistic 3D models in augmented reality"
        ),
        OnboardingItem(
            image: "onboarding3",
            title: "Voice Assistant",
            description: "Use Siri to navigate through historical sites and learn about wildlife"
        ),
        OnboardingItem(
            image: "onboarding4",
            title: "Offline Access",
            description: "Access saved locations and educational materials even without internet"
        )
    ]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryGreen").ignoresSafeArea()
                
                VStack {
                    onboardingPager
                    Spacer()
                    navigationButtons
                }

                NavigationLink(
                    destination: SplashScreen(),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Components
    private var onboardingPager: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<onboardingItems.count) { index in
                OnboardingPageView(item: onboardingItems[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }

    private var navigationButtons: some View {
        HStack(spacing: 20) {
            if currentPage < onboardingItems.count - 1 {
                Button("Skip") {
                    navigateToLoginScreen()
                }
                .foregroundColor(.gray)

                Spacer()

                Button("Next") {
                    moveToNextPage()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color("PrimaryAccent"))
                .cornerRadius(25)
            } else {
                Button(action: navigateToLoginScreen) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryAccent"))
                        .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 40)
    }

    // MARK: - Logic
    private func moveToNextPage() {
        withAnimation {
            currentPage += 1
        }
    }

    private func navigateToLoginScreen() {
        withAnimation {
            navigateToLogin = true
        }
    }
}

/// A single page in the onboarding sequence
struct OnboardingPageView: View {
    let item: OnboardingItem

    var body: some View {
        VStack(spacing: 20) {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .padding()

            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(item.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

// MARK: - Preview
struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
           
    }
}

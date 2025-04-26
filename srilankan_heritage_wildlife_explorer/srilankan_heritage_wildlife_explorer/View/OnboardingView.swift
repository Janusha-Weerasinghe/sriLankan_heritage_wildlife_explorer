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
struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var navigateToLogin = false
    
    private let onboardingItems = [
        OnboardingItem(
            image: "onboarding1", // Make sure these images exist in Assets.xcassets
            title: "Explore Heritage",
            description: "Discover Sri Lanka's ancient wonders with immersive AR experiences."
        ),
        OnboardingItem(
            image: "onboarding2",
            title: "Wildlife in 3D",
            description: "Meet native wildlife up close through lifelike 3D models."
        ),
        OnboardingItem(
            image: "onboarding3",
            title: "Voice Navigation",
            description: "Use Siri to guide your journey through culture and nature."
        ),
        OnboardingItem(
            image: "onboarding4",
            title: "Offline Mode",
            description: "Access saved locations even when you're offline."
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                //Color(.systemBackground).ignoresSafeArea()
                Color("OnboardingBackground").ignoresSafeArea()
                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingItems.count, id: \.self) { index in
                            OnboardingPageView(item: onboardingItems[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .animation(.easeInOut, value: currentPage)
                    .accessibilityElement(children: .contain)
                    
                    Spacer()
                    
                    HStack {
                        if currentPage < onboardingItems.count - 1 {
                            Button("Skip") {
                                navigateToLogin = true
                            }
                            .font(.headline)
                            .foregroundColor(.gray)
                            .accessibilityLabel("Skip to login")
                            
                            Spacer()
                            
                            Button("Next") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .font(.headline)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .accessibilityLabel("Next onboarding screen")
                        } else {
                            Button(action: {
                                navigateToLogin = true
                            }) {
                                Text("Get Started")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .accessibilityLabel("Start exploring")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
                
                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        }
    }
}

/// A single onboarding page
struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 20) {
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .padding()
                .accessibilityHidden(true) // alt text could be added here if needed
            
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)
            
            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//struct LoginScreen: View {
//    var body: some View {
//        Text("Login Screen")
//            .font(.largeTitle)
//            .navigationBarTitle("Login", displayMode: .inline)
//    }
//}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

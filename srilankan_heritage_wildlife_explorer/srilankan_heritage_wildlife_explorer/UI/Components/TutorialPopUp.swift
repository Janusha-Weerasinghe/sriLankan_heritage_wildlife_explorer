//
//  TutorialPopUp.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//
import SwiftUI

// MARK: - TutorialPopup Model
struct TutorialItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

// MARK: - TutorialPopupView
/// A reusable component for displaying tutorial pop-ups to first-time users
struct TutorialPopupView: View {
    // MARK: - Properties
    @Binding var isShowingTutorial: Bool
    @State private var currentPage = 0
    
    // Sample tutorial items - In a real app, these would come from a data source
    private let tutorialItems = [
        TutorialItem(
            image: "ar.camera",
            title: "Explore with AR",
            description: "Point your camera at landmarks to see historical information and 3D models in augmented reality."
        ),
        TutorialItem(
            image: "map",
            title: "Interactive Map",
            description: "Discover heritage sites and wildlife locations with our detailed interactive map."
        ),
        TutorialItem(
            image: "person.crop.circle.badge.questionmark",
            title: "Ask Siri",
            description: "Use voice commands with Siri to navigate and learn about Sri Lanka's heritage and wildlife."
        )
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            // Tutorial content
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button {
                        isShowingTutorial = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<tutorialItems.count, id: \.self) { index in
                        tutorialPageView(item: tutorialItems[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                // Navigation buttons
                HStack(spacing: 40) {
                    Button {
                        withAnimation {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                    } label: {
                        Text("Previous")
                            .fontWeight(.medium)
                            .foregroundColor(currentPage > 0 ? .white : .gray)
                    }
                    .disabled(currentPage == 0)
                    
                    Button {
                        withAnimation {
                            if currentPage < tutorialItems.count - 1 {
                                currentPage += 1
                            } else {
                                isShowingTutorial = false
                            }
                        }
                    } label: {
                        Text(currentPage < tutorialItems.count - 1 ? "Next" : "Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
    
    // MARK: - Helper Views
    /// Creates a single page view for the tutorial
    private func tutorialPageView(item: TutorialItem) -> some View {
        VStack(spacing: 25) {
            Image(systemName: item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
            
            Text(item.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 20)
    }
}

// MARK: - Preview Provider
struct TutorialPopupView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPopupView(isShowingTutorial: .constant(true))
    }
}

// MARK: - Tutorial Manager
/// Manages the tutorial state across the app
class TutorialManager: ObservableObject {
    // MARK: - Published Properties
    @Published var hasCompletedTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedTutorial, forKey: "hasCompletedTutorial")
        }
    }
    
    // MARK: - Initialization
    init() {
        // Check if the user has completed the tutorial
        self.hasCompletedTutorial = UserDefaults.standard.bool(forKey: "hasCompletedTutorial")
    }
    
    // MARK: - Methods
    /// Reset tutorial status (for testing or when a major update occurs)
    func resetTutorialStatus() {
        hasCompletedTutorial = false
    }
}

// MARK: - Usage Example
struct ContentViewWithTutorial: View {
    @StateObject private var tutorialManager = TutorialManager()
    @State private var showingTutorial = false
    
    var body: some View {
        ZStack {
            // Your main app content here
            Text("Main App Content")
            
            // Show tutorial if needed
            if showingTutorial {
                TutorialPopupView(isShowingTutorial: $showingTutorial)
            }
        }
        .onAppear {
            // Show tutorial on first launch
            if !tutorialManager.hasCompletedTutorial {
                showingTutorial = true
            }
        }
        .onChange(of: showingTutorial) { newValue in
            // Mark tutorial as completed when user dismisses it
            if !newValue {
                tutorialManager.hasCompletedTutorial = true
            }
        }
    }
}

//
//  ARTotorialView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import SwiftUI

struct ARTutorialView: View {
    @EnvironmentObject var viewModel: HeritageViewModel
    @State private var currentPage = 0
    
    // Tutorial content
    private let tutorialPages = [
        TutorialPage(
            title: "Welcome to AR Explorer",
            description: "Experience Sri Lankan heritage and wildlife in augmented reality",
            imageName: "ar.tutorial.welcome"
        ),
        TutorialPage(
            title: "Point Your Camera",
            description: "Point your device at a flat surface to place the 3D model",
            imageName: "ar.tutorial.camera"
        ),
        TutorialPage(
            title: "Interact with Models",
            description: "Pinch to resize, drag to rotate, and tap for more information",
            imageName: "ar.tutorial.interact"
        )
    ]
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Spacer()
                Button(action: {
                    viewModel.proceedToARView()
                }) {
                    Text("Skip")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            TabView(selection: $currentPage) {
                ForEach(0..<tutorialPages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        // Placeholder for image
                        Image(systemName: "arkit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                        
                        Text(tutorialPages[index].title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(tutorialPages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            // Next/Start Button
            Button(action: {
                if currentPage < tutorialPages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    viewModel.proceedToARView()
                }
            }) {
                Text(currentPage < tutorialPages.count - 1 ? "Next" : "Start Exploring")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
    }
}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}
// MARK: - Preview

struct ARTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        ARTutorialView()
           
    }
}

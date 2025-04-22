//
//  Loading.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-22.
//

import SwiftUI

// MARK: - Loading & Transition Animations Screen
struct LoadingView: View {
    // State variables to control animations
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.8
    @State private var rotationDegree: Double = 0
    @State private var opacity: Double = 0.7
    
    // Timer for continuous animations
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.07450980392, green: 0.4431372549, blue: 0.4431372549, alpha: 1)), Color(#colorLiteral(red: 0.1098039216, green: 0.2666666667, blue: 0.2666666667, alpha: 1))]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // App logo
                Image("app_logo") // Replace with your app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(logoScale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotationDegree))
                    .animation(.easeInOut(duration: 1.0), value: logoScale)
                    .animation(.easeInOut(duration: 1.0), value: opacity)
                    .animation(.easeInOut(duration: 1.0), value: rotationDegree)
                
                Text("AR Heritage & Wildlife Explorer")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)
                
                // Loading indicator
                LoadingIndicator(isAnimating: $isAnimating)
                    .frame(width: 50, height: 50)
                
                Text("Loading Sri Lankan treasures...")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(opacity)
            }
            .onAppear {
                // Start animations when view appears
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    logoScale = 1.0
                    opacity = 1.0
                    isAnimating = true
                }
                
                // Rotation animation
                withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                    rotationDegree = 360
                }
            }
            .onReceive(timer) { _ in
                // Update animations on timer
                withAnimation {
                    isAnimating.toggle()
                }
            }
        }
    }
}

// MARK: - Custom Loading Indicator Component
struct LoadingIndicator: View {
    @Binding var isAnimating: Bool
    @State private var animationValues: [Double] = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<6) { index in
                Capsule()
                    .fill(Color.white)
                    .frame(width: 4, height: 20 * animationValues[index])
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            // Rotate animation values for continuous effect
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                let lastValue = self.animationValues.removeFirst()
                self.animationValues.append(lastValue)
            }
        }
    }
}

// MARK: - Transition Animations Manager
/// Class responsible for handling all transition animations in the app
class TransitionAnimator {
    // Available transition types
    enum TransitionType {
        case fade
        case slide
        case scale
        case reveal
        case rotate
    }
    
    /// Returns the appropriate animation for the given transition type
    /// - Parameters:
    ///   - type: The type of transition animation
    ///   - duration: The duration of the animation (default: 0.5)
    /// - Returns: An AnyTransition that can be applied to a SwiftUI view
    static func getTransition(type: TransitionType, duration: Double = 0.5) -> AnyTransition {
        switch type {
        case .fade:
            return AnyTransition.opacity
                .animation(.easeInOut(duration: duration))
        case .slide:
            return AnyTransition.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ).animation(.easeInOut(duration: duration))
        case .scale:
            return AnyTransition.scale(scale: 0.8)
                .combined(with: .opacity)
                .animation(.easeInOut(duration: duration))
        case .reveal:
            return AnyTransition.asymmetric(
                insertion: .push(from: .bottom),
                removal: .push(from: .top)
            ).animation(.easeInOut(duration: duration))
        case .rotate:
            return AnyTransition.modifier(
                active: RotationModifier(rotation: .degrees(90), opacity: 0),
                identity: RotationModifier(rotation: .degrees(0), opacity: 1)
            ).animation(.easeInOut(duration: duration))
        }
    }
}

// MARK: - Custom Rotation Modifier
/// Custom ViewModifier for rotation transitions
struct RotationModifier: ViewModifier {
    let rotation: Angle
    let opacity: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(rotation)
            .opacity(opacity)
    }
}

// MARK: - Screen Transition Extensions
extension View {
    /// Applies a standard page transition to the view
    /// - Parameter type: The type of transition to apply
    /// - Returns: View with transition applied
    func pageTransition(_ type: TransitionAnimator.TransitionType) -> some View {
        self.transition(TransitionAnimator.getTransition(type: type))
    }
    
    /// Applies a quick transition for UI elements
    /// - Returns: View with quick transition applied
    func quickTransition() -> some View {
        self.transition(TransitionAnimator.getTransition(type: .fade, duration: 0.3))
    }
}

// MARK: - Preview Provider
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

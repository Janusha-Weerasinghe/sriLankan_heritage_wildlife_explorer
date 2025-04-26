//
//  ARViewContainer.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//
import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var viewModel: HeritageViewModel
    
    var heritage: HeritageItem?
    var wildlife: WildlifeItem?
    
    init(item: HeritageItem? = nil, wildlife: WildlifeItem? = nil) {
        self.heritage = item
        self.wildlife = wildlife
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Add coaching overlay for better AR experience
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.frame = arView.frame
        arView.addSubview(coachingOverlay)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        // Load appropriate 3D model
        if let heritage = heritage, let modelName = heritage.arModelName {
            loadModel(named: modelName, in: arView, context: context)
        } else if let wildlife = wildlife, let modelName = wildlife.arModelName {
            loadModel(named: modelName, in: arView, context: context)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update logic if needed
    }
    
    private func loadModel(named modelName: String, in arView: ARView, context: Context) {
        // Check if model exists
        guard let modelEntity = try? ModelEntity.loadModel(named: modelName) else {
            print("Failed to load model: \(modelName)")
            return
        }
        
        // Scale the model
        modelEntity.scale = SIMD3<Float>(0.5, 0.5, 0.5)
        
        // Create anchor for the model
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(modelEntity)
        
        // Add anchor to the scene
        arView.scene.addAnchor(anchor)
        
        // Store reference to coordinator for interactions
        context.coordinator.modelEntity = modelEntity
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var modelEntity: ModelEntity?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            
            let location = gesture.location(in: arView)
            
            // Perform hit test
            if let entity = arView.entity(at: location) as? ModelEntity {
                // Show info about the entity
                showInfo(for: entity)
            }
        }
        
        private func showInfo(for entity: ModelEntity) {
            // Display information about the tapped object
            var title: String = "Information"
            var message: String = "Explore more about this item."
            
            if let heritage = parent.heritage {
                title = heritage.name
                message = heritage.description
            } else if let wildlife = parent.wildlife {
                title = wildlife.name
                message = wildlife.description
            }
            
            // Create UI alert controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
            
            // Present the alert
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(alertController, animated: true)
            }
        }
    }
}

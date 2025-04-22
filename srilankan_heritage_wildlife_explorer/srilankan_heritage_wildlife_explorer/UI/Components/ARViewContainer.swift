////
////  ARViewContainer.swift
////  srilankan_heritage_wildlife_explorer
////
////  Created by Janusha 023 on 2025-04-22.
////
//
//import SwiftUI
//import ARKit
//import RealityKit
//import Combine
//
///**
// ARCameraView is responsible for managing the AR camera functionality
// and rendering 3D models of heritage sites and wildlife in augmented reality.
// This view handles camera permissions, AR session configuration,
// model placement, and interaction with 3D objects.
// */
//struct ARCameraView: View {
//    // MARK: - State Properties
//    
//    /// State to track if model info panel is shown
//    @State private var isInfoPanelVisible = false
//    
//    /// State to track if model is loading
//    @State private var isLoading = false
//    
//    /// State to track if instructions should be displayed
//    @State private var showInstructions = true
//    
//    /// State to track current instruction text
//    @State private var instructionText = "Move your device around to place the model"
//    
//    /// State to track if success indicator should be shown
//    @State private var showSuccessIndicator = false
//    
//    /// Current model information
//    @State private var modelInfo: ModelInformation?
//    
//    /// Indicates if the current model is a favorite
//    @State private var isFavorite = false
//    
//    /// Environment to present alerts
//    @Environment(\.presentationMode) var presentationMode
//    
//    // MARK: - Properties
//    
//    /// Cancellable subscriptions for async operations
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - Body
//    var body: some View {
//        ZStack {
//            // AR View container
//            ARViewContainer(
//                modelInfo: $modelInfo,
//                isLoading: $isLoading,
//                instructionText: $instructionText,
//                showInstructions: $showInstructions
//            )
//            .edgesIgnoringSafeArea(.all)
//            
//            // UI Overlay
//            VStack {
//                // Top controls
//                HStack {
//                    // Back button
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "arrow.left.circle.fill")
//                            .font(.system(size: 22))
//                            .padding(12)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Circle())
//                    }
//                    
//                    Spacer()
//                    
//                    // Info button
//                    Button(action: {
//                        withAnimation {
//                            isInfoPanelVisible.toggle()
//                        }
//                    }) {
//                        Image(systemName: "info.circle.fill")
//                            .font(.system(size: 22))
//                            .padding(12)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Circle())
//                    }
//                }
//                .padding()
//                
//                // Instructions
//                if showInstructions {
//                    Text(instructionText)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.5))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                        .onAppear {
//                            // Auto-hide instruction after 5 seconds
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                withAnimation {
//                                    showInstructions = false
//                                }
//                            }
//                        }
//                }
//                
//                Spacer()
//                
//                // Model Info Panel
//                if isInfoPanelVisible {
//                    modelInfoPanel
//                        .transition(.move(edge: .bottom))
//                }
//                
//                // Capture button
//                Button(action: captureScreenshot) {
//                    Image(systemName: "camera.fill")
//                        .font(.system(size: 24))
//                        .padding(16)
//                        .background(Color.black.opacity(0.5))
//                        .clipShape(Circle())
//                }
//                .padding(.bottom)
//            }
//            
//            // Loading indicator
//            if isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    .scaleEffect(1.5)
//                    .frame(width: 80, height: 80)
//                    .background(Color.black.opacity(0.5))
//                    .cornerRadius(15)
//            }
//            
//            // Success indicator for screenshot
//            if showSuccessIndicator {
//                Image(systemName: "checkmark.circle.fill")
//                    .font(.system(size: 50))
//                    .foregroundColor(.white)
//                    .frame(width: 80, height: 80)
//                    .background(Color.black.opacity(0.7))
//                    .clipShape(Circle())
//                    .onAppear {
//                        // Auto-hide success indicator after 1.5 seconds
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                            withAnimation {
//                                showSuccessIndicator = false
//                            }
//                        }
//                    }
//            }
//        }
//        .foregroundColor(.white)
//        .onAppear {
//            checkCameraPermission()
//        }
//    }
//    
//    // MARK: - Model Info Panel
//    
//    private var modelInfoPanel: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text(modelInfo?.name ?? "Model Information")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                
//                Spacer()
//                
//                Button(action: toggleFavorite) {
//                    Image(systemName: isFavorite ? "heart.fill" : "heart")
//                        .foregroundColor(isFavorite ? .red : .white)
//                }
//            }
//            
//            ScrollView {
//                Text(modelInfo?.description ?? "No description available")
//                    .font(.body)
//                    .foregroundColor(.white)
//            }
//        }
//        .padding()
//        .background(Color.black.opacity(0.7))
//        .cornerRadius(15)
//        .padding(.horizontal)
//        .padding(.bottom, 8)
//    }
//    
//    // MARK: - Methods
//    
//    /**
//     Checks if camera permission is granted and requests it if needed.
//     */
//    private func checkCameraPermission() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            // Camera permission already granted
//            break
//        case .notDetermined:
//            // Request camera permission
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if !granted {
//                    showCameraPermissionAlert()
//                }
//            }
//        case .denied, .restricted:
//            showCameraPermissionAlert()
//        @unknown default:
//            break
//        }
//    }
//    
//    /**
//     Shows an alert when camera permission is denied.
//     */
//    private func showCameraPermissionAlert() {
//        // In a real app, you would use SwiftUI's .alert modifier here
//        // For this conversion, we're keeping the logic but implementation would change
//        DispatchQueue.main.async {
//            // Would be replaced with SwiftUI alert implementation
//            print("Camera permission denied - implement SwiftUI alert here")
//            presentationMode.wrappedValue.dismiss()
//        }
//    }
//    
//    /**
//     Captures the current screen as a screenshot.
//     */
//    private func captureScreenshot() {
//        // Hide info panel for screenshot
//        let infoPanelWasVisible = isInfoPanelVisible
//        isInfoPanelVisible = false
//        
//        // In SwiftUI, capturing screenshots requires a different approach
//        // This would typically be done using UIView/UIKit interop
//        // For now, we'll show the success indicator to simulate success
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            withAnimation {
//                showSuccessIndicator = true
//            }
//            
//            // Restore info panel visibility
//            if infoPanelWasVisible {
//                isInfoPanelVisible = true
//            }
//        }
//    }
//    
//    /**
//     Toggles the favorite status of the current model.
//     */
//    private func toggleFavorite() {
//        guard let info = modelInfo else { return }
//        
//        isFavorite = FavoritesManager.shared.toggleFavorite(id: info.id, info: info)
//    }
//}
//
///**
// UIViewRepresentable wrapper for ARView.
// */
//struct ARViewContainer: UIViewRepresentable {
//    // MARK: - Binding Properties
//    
//    @Binding var modelInfo: ModelInformation?
//    @Binding var isLoading: Bool
//    @Binding var instructionText: String
//    @Binding var showInstructions: Bool
//    
//    // MARK: - Properties
//    
//    /// Current AR model being displayed
//    private var currentModel: Entity?
//    
//    /// Cancellable subscriptions for async operations
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - UIViewRepresentable Methods
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        arView.automaticallyConfigureSession = false
//        
//        // Configure AR session
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        arView.session.run(configuration)
//        
//        // Add gesture recognizers
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
//        
//        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
//        arView.addGestureRecognizer(pinchGesture)
//        
//        let rotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleRotation(_:)))
//        arView.addGestureRecognizer(rotationGesture)
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//        context.coordinator.arView = uiView
//        
//        // Load model if modelInfo exists and hasn't been loaded
//        if let info = modelInfo, context.coordinator.currentModelName != info.id {
//            context.coordinator.currentModelName = info.id
//            loadModel(modelName: info.id, info: info, arView: uiView, coordinator: context.coordinator)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // MARK: - Coordinator
//    
//    class Coordinator: NSObject {
//        var parent: ARViewContainer
//        var arView: ARView?
//        var currentModel: Entity?
//        var currentModelName: String?
//        
//        init(_ parent: ARViewContainer) {
//            self.parent = parent
//        }
//        
//        /**
//         Handles tap gestures on the AR view to place models.
//         */
//        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
//            guard let arView = arView, let model = currentModel else { return }
//            
//            // Get tap location
//            let tapLocation = gesture.location(in: arView)
//            
//            // Perform hit test to find surface
//            let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
//            
//            if let firstResult = results.first {
//                // Create anchor at hit location
//                let anchor = ARAnchor(name: "modelAnchor", transform: firstResult.worldTransform)
//                arView.session.add(anchor: anchor)
//                
//                // Create anchor entity
//                let anchorEntity = AnchorEntity(anchor: anchor)
//                
//                // Clone model to allow multiple placements
//                let modelClone = model.clone(recursive: true)
//                
//                // Add model to anchor
//                anchorEntity.addChild(modelClone)
//                
//                // Add anchor to scene
//                arView.scene.addAnchor(anchorEntity)
//                
//                // Update instruction
//                parent.instructionText = "Pinch to scale, rotate with two fingers"
//                parent.showInstructions = true
//                
//                // Auto-hide instruction after 3 seconds
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    parent.showInstructions = false
//                }
//            }
//        }
//        
//        /**
//         Handles pinch gestures to scale models.
//         */
//        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
//            guard let arView = arView, let frame = arView.session.currentFrame else { return }
//            
//            // Get camera position
//            let cameraTransform = frame.camera.transform
//            let cameraPosition = simd_make_float3(cameraTransform.columns.3)
//            
//            // Perform hit test from camera position
//            let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
//            let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .any)
//            
//            if let result = results.first {
//                let hitPosition = simd_make_float3(result.worldTransform.columns.3)
//                
//                // Find closest entity to hit position
//                if let entity = findClosestEntity(to: hitPosition) {
//                    // Scale entity based on pinch gesture
//                    switch gesture.state {
//                    case .changed:
//                        entity.transform.scale *= Float(gesture.scale)
//                        gesture.scale = 1.0
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//        
//        /**
//         Handles rotation gestures to rotate models.
//         */
//        @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
//            guard let arView = arView, let frame = arView.session.currentFrame else { return }
//            
//            // Get camera position
//            let cameraTransform = frame.camera.transform
//            let cameraPosition = simd_make_float3(cameraTransform.columns.3)
//            
//            // Perform hit test from camera position
//            let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
//            let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .any)
//            
//            if let result = results.first {
//                let hitPosition = simd_make_float3(result.worldTransform.columns.3)
//                
//                // Find closest entity to hit position
//                if let entity = findClosestEntity(to: hitPosition) {
//                    // Rotate entity based on rotation gesture
//                    switch gesture.state {
//                    case .changed:
//                        let rotation = simd_quatf(angle: Float(gesture.rotation), axis: [0, 1, 0])
//                        entity.transform.rotation = entity.transform.rotation * rotation
//                        gesture.rotation = 0
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//        
//        /**
//         Finds the closest entity to a given position.
//         */
//        private func findClosestEntity(to position: simd_float3) -> Entity? {
//            guard let arView = arView else { return nil }
//            
//            var closestDistance = Float.greatestFiniteMagnitude
//            var closestEntity: Entity? = nil
//            
//            // Find all anchor entities
//            arView.scene.anchors.forEach { anchor in
//                // Check all children of anchors
//                findEntitiesRecursively(in: anchor).forEach { entity in
//                    // Calculate distance between entity and position
//                    let entityPosition = entity.position(relativeTo: nil)
//                    let distance = simd_distance(entityPosition, position)
//                    
//                    // Keep track of closest entity
//                    if distance < closestDistance {
//                        closestDistance = distance
//                        closestEntity = entity
//                    }
//                }
//            }
//            
//            return closestEntity
//        }
//        
//        /**
//         Recursively finds all entities in a parent entity.
//         */
//        private func findEntitiesRecursively(in parent: Entity) -> [Entity] {
//            var entities: [Entity] = []
//            
//            // Add parent
//            entities.append(parent)
//            
//            // Add all children recursively
//            for child in parent.children {
//                entities.append(contentsOf: findEntitiesRecursively(in: child))
//            }
//            
//            return entities
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    /**
//     Loads the 3D model for display in AR.
//     */
//    private func loadModel(modelName: String, info: ModelInformation, arView: ARView, coordinator: Coordinator) {
//        isLoading = true
//        
//        // Check if model is favorite
//        let isFavorite = FavoritesManager.shared.isFavorite(id: info.id)
//        
//        // Load model asynchronously
//        ModelLoader.loadModel(named: modelName)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                isLoading = false
//                
//                if case .failure(let error) = completion {
//                    print("Error loading model: \(error.localizedDescription)")
//                    // In a real app, we would show an error alert here
//                }
//            }, receiveValue: { model in
//                coordinator.currentModel = model
//                instructionText = "Tap on a surface to place the model"
//                showInstructions = true
//            })
//            .store(in: &cancellables)
//    }
//}
//
///**
// Model representing information about a heritage site or wildlife.
// */
//struct ModelInformation: Codable, Identifiable, Equatable {
//    let id: String
//    let name: String
//    let type: ModelType
//    let description: String
//    let location: String?
//    let coordinates: Coordinates?
//    
//    enum ModelType: String, Codable {
//        case heritageSite
//        case wildlife
//    }
//    
//    struct Coordinates: Codable, Equatable {
//        let latitude: Double
//        let longitude: Double
//    }
//}
//
///**
// Service responsible for loading models from various sources.
// */
//class ModelLoader {
//    /**
//     Loads a model by name.
//     */
//    static func loadModel(named modelName: String) -> AnyPublisher<Entity, Error> {
//        return Future<Entity, Error> { promise in
//            // First try to load from local storage (for offline use)
//            if let localModel = loadModelFromLocalStorage(named: modelName) {
//                promise(.success(localModel))
//                return
//            }
//            
//            // If not available locally, load from bundle
//            if let bundleURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
//                do {
//                    let entity = try Entity.load(contentsOf: bundleURL)
//                    
//                    // Save model for offline use
//                    saveModelToLocalStorage(entity, named: modelName)
//                    
//                    promise(.success(entity))
//                } catch {
//                    promise(.failure(error))
//                }
//                return
//            }
//            
//            // If not available in bundle, use a placeholder
//            if let placeholderURL = Bundle.main.url(forResource: "placeholderModel", withExtension: "usdz") {
//                do {
//                    let entity = try Entity.load(contentsOf: placeholderURL)
//                    promise(.success(entity))
//                } catch {
//                    promise(.failure(error))
//                }
//                return
//            }
//            
//            // If all else fails, create a simple box
//            let box = ModelEntity(mesh: .generateBox(size: 0.1))
//            box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
//            promise(.success(box))
//        }
//        .eraseToAnyPublisher()
//    }
//    
//    /**
//     Loads a model from local storage.
//     */
//    private static func loadModelFromLocalStorage(named modelName: String) -> Entity? {
//        let fileManager = FileManager.default
//        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return nil
//        }
//        
//        let modelURL = documentsDirectory.appendingPathComponent("\(modelName).usdz")
//        
//        if fileManager.fileExists(atPath: modelURL.path) {
//            do {
//                return try Entity.load(contentsOf: modelURL)
//            } catch {
//                print("Error loading model from local storage: \(error)")
//                return nil
//            }
//        }
//        
//        return nil
//    }
//    
//    /**
//     Saves a model to local storage for offline use.
//     */
//    private static func saveModelToLocalStorage(_ entity: Entity, named modelName: String) {
//        // Implementation would depend on RealityKit's export capabilities
//        // This is a placeholder as direct export functionality is limited
//        print("Saving model to local storage: \(modelName)")
//    }
//}
//
///**
// Manager for handling user favorites.
// */
//class FavoritesManager {
//    static let shared = FavoritesManager()
//    
//    private let favoritesKey = "userFavorites"
//    private var favorites: [String: ModelInformation] = [:]
//    
//    private init() {
//        loadFavorites()
//    }
//    
//    /**
//     Loads favorites from UserDefaults.
//     */
//    private func loadFavorites() {
//        if let data = UserDefaults.standard.data(forKey: favoritesKey),
//           let decoded = try? JSONDecoder().decode([String: ModelInformation].self, from: data) {
//            favorites = decoded
//        }
//    }
//    
//    /**
//     Saves favorites to UserDefaults.
//     */
//    private func saveFavorites() {
//        if let encoded = try? JSONEncoder().encode(favorites) {
//            UserDefaults.standard.set(encoded, forKey: favoritesKey)
//        }
//    }
//    
//    /**
//     Checks if a model is favorited.
//     */
//    func isFavorite(id: String) -> Bool {
//        return favorites[id] != nil
//    }
//    
//    /**
//     Toggles the favorite status of a model.
//     */
//    func toggleFavorite(id: String, info: ModelInformation) -> Bool {
//        if isFavorite(id: id) {
//            favorites.removeValue(forKey: id)
//            saveFavorites()
//            return false
//        } else {
//            favorites[id] = info
//            saveFavorites()
//            return true
//        }
//    }
//}
//
///**
// Preview provider for SwiftUI Canvas preview.
// */
//struct ARCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARCameraView()
//    }
//}

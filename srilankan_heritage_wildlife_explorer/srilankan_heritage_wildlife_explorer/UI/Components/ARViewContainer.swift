//
//  ARViewContainer.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import UIKit
import ARKit
import RealityKit
import Combine

/**
 ARCameraViewController is responsible for managing the AR camera functionality
 and rendering 3D models of heritage sites and wildlife in augmented reality.
 This view controller handles camera permissions, AR session configuration,
 model placement, and interaction with 3D objects.
 */
class ARCameraViewController: UIViewController {
    
    // MARK: - Properties
    
    /// AR view that renders the camera feed and 3D content
    private var arView: ARView!
    
    /// Current AR model being displayed
    private var currentModel: Entity?
    
    /// Information about the currently displayed model
    private var modelInfo: ModelInformation?
    
    /// Cancellable subscriptions for async operations
    private var cancellables = Set<AnyCancellable>()
    
    /// Model loading state
    private var isLoading = false {
        didSet {
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = !self.isLoading
                if self.isLoading {
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - UI Elements
    
    /// Loading indicator shown during model loading
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// Button to go back to previous screen
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Button to take a screenshot
    private lazy var captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Button to toggle information panel
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Container view for model information
    private lazy var infoPanel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 15
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Label for model name
    private lazy var modelNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Text view for model description
    private lazy var modelDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    /// Button to add model to favorites
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Label for AR usage instructions
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Move your device around to place the model"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupARView()
        setupUI()
        checkCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause AR session to save battery
        arView.session.pause()
    }
    
    // MARK: - Setup Methods
    
    /**
     Sets up the AR view and its configuration.
     */
    private func setupARView() {
        arView = ARView(frame: view.bounds)
        arView.automaticallyConfigureSession = false
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add tap gesture recognizer to place models
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        // Add pinch gesture for scaling models
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        arView.addGestureRecognizer(pinchGesture)
        
        // Add rotation gesture
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        arView.addGestureRecognizer(rotationGesture)
    }
    
    /**
     Sets up the user interface components.
     */
    private func setupUI() {
        // Add UI elements to view hierarchy
        view.addSubview(backButton)
        view.addSubview(captureButton)
        view.addSubview(infoButton)
        view.addSubview(loadingIndicator)
        view.addSubview(instructionLabel)
        view.addSubview(infoPanel)
        
        // Add elements to info panel
        infoPanel.addSubview(modelNameLabel)
        infoPanel.addSubview(modelDescriptionTextView)
        infoPanel.addSubview(favoriteButton)
        
        // Set up auto layout constraints
        NSLayoutConstraint.activate([
            // Back button constraints
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Info button constraints
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoButton.widthAnchor.constraint(equalToConstant: 50),
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Capture button constraints
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 60),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Loading indicator constraints
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Instruction label constraints
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            instructionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Info panel constraints
            infoPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoPanel.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20),
            infoPanel.heightAnchor.constraint(equalToConstant: 200),
            
            // Model name label constraints
            modelNameLabel.topAnchor.constraint(equalTo: infoPanel.topAnchor, constant: 15),
            modelNameLabel.leadingAnchor.constraint(equalTo: infoPanel.leadingAnchor, constant: 15),
            modelNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),
            
            // Favorite button constraints
            favoriteButton.topAnchor.constraint(equalTo: infoPanel.topAnchor, constant: 15),
            favoriteButton.trailingAnchor.constraint(equalTo: infoPanel.trailingAnchor, constant: -15),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Model description text view constraints
            modelDescriptionTextView.topAnchor.constraint(equalTo: modelNameLabel.bottomAnchor, constant: 10),
            modelDescriptionTextView.leadingAnchor.constraint(equalTo: infoPanel.leadingAnchor, constant: 10),
            modelDescriptionTextView.trailingAnchor.constraint(equalTo: infoPanel.trailingAnchor, constant: -10),
            modelDescriptionTextView.bottomAnchor.constraint(equalTo: infoPanel.bottomAnchor, constant: -10)
        ])
    }
    
    /**
     Checks if camera permission is granted and requests it if needed.
     */
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera permission already granted
            break
        case .notDetermined:
            // Request camera permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if !granted {
                    self?.showCameraPermissionAlert()
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            break
        }
    }
    
    /**
     Shows an alert when camera permission is denied.
     */
    private func showCameraPermissionAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Camera Access Required",
                message: "AR features require camera access. Please enable camera access in Settings.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.dismiss(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Model Loading
    
    /**
     Loads the 3D model for display in AR.
     
     - Parameter modelName: The name of the model to load
     */
    func loadModel(modelName: String, info: ModelInformation) {
        self.modelInfo = info
        self.modelNameLabel.text = info.name
        self.modelDescriptionTextView.text = info.description
        
        // Check if model is favorited
        updateFavoriteButton(isFavorite: FavoritesManager.shared.isFavorite(id: info.id))
        
        isLoading = true
        
        // Load model asynchronously
        ModelLoader.loadModel(named: modelName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.showModelLoadingError(error)
                }
            }, receiveValue: { [weak self] model in
                self?.currentModel = model
                self?.instructionLabel.text = "Tap on a surface to place the model"
                self?.instructionLabel.isHidden = false
                
                // Auto-hide instruction after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    UIView.animate(withDuration: 0.5) {
                        self?.instructionLabel.alpha = 0
                    } completion: { _ in
                        self?.instructionLabel.isHidden = true
                        self?.instructionLabel.alpha = 1
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    /**
     Shows an error alert when model loading fails.
     
     - Parameter error: The error that occurred during loading
     */
    private func showModelLoadingError(_ error: Error) {
        let alert = UIAlertController(
            title: "Model Loading Error",
            message: "Failed to load the 3D model: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    // MARK: - AR Interaction Methods
    
    /**
     Handles tap gestures on the AR view to place models.
     
     - Parameter gesture: The tap gesture recognizer
     */
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let model = currentModel else { return }
        
        // Get tap location
        let tapLocation = gesture.location(in: arView)
        
        // Perform hit test to find surface
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = results.first {
            // Create anchor at hit location
            let anchor = ARAnchor(name: "modelAnchor", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
            
            // Create anchor entity
            let anchorEntity = AnchorEntity(anchor: anchor)
            
            // Clone model to allow multiple placements
            let modelClone = model.clone(recursive: true)
            
            // Add model to anchor
            anchorEntity.addChild(modelClone)
            
            // Add anchor to scene
            arView.scene.addAnchor(anchorEntity)
            
            // Update instruction
            instructionLabel.text = "Pinch to scale, rotate with two fingers"
            
            // Show instruction briefly
            instructionLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
                self.instructionLabel.alpha = 0
            }) { _ in
                self.instructionLabel.isHidden = true
                self.instructionLabel.alpha = 1
            }
        }
    }
    
    /**
     Handles pinch gestures to scale models.
     
     - Parameter gesture: The pinch gesture recognizer
     */
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let frame = arView.session.currentFrame else { return }
        
        // Get camera position
        let cameraTransform = frame.camera.transform
        let cameraPosition = simd_make_float3(cameraTransform.columns.3)
        
        // Perform hit test from camera position
        let results = arView.raycast(from: view.center, allowing: .estimatedPlane, alignment: .any)
        
        if let result = results.first {
            let hitPosition = simd_make_float3(result.worldTransform.columns.3)
            
            // Find closest entity to hit position
            if let entity = findClosestEntity(to: hitPosition) {
                // Scale entity based on pinch gesture
                switch gesture.state {
                case .changed:
                    entity.transform.scale *= Float(gesture.scale)
                    gesture.scale = 1.0
                default:
                    break
                }
            }
        }
    }
    
    /**
     Handles rotation gestures to rotate models.
     
     - Parameter gesture: The rotation gesture recognizer
     */
    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let frame = arView.session.currentFrame else { return }
        
        // Get camera position
        let cameraTransform = frame.camera.transform
        let cameraPosition = simd_make_float3(cameraTransform.columns.3)
        
        // Perform hit test from camera position
        let results = arView.raycast(from: view.center, allowing: .estimatedPlane, alignment: .any)
        
        if let result = results.first {
            let hitPosition = simd_make_float3(result.worldTransform.columns.3)
            
            // Find closest entity to hit position
            if let entity = findClosestEntity(to: hitPosition) {
                // Rotate entity based on rotation gesture
                switch gesture.state {
                case .changed:
                    let rotation = simd_quatf(angle: Float(gesture.rotation), axis: [0, 1, 0])
                    entity.transform.rotation = entity.transform.rotation * rotation
                    gesture.rotation = 0
                default:
                    break
                }
            }
        }
    }
    
    /**
     Finds the closest entity to a given position.
     
     - Parameter position: The position to find the closest entity to
     - Returns: The closest entity, if any
     */
    private func findClosestEntity(to position: simd_float3) -> Entity? {
        var closestDistance = Float.greatestFiniteMagnitude
        var closestEntity: Entity? = nil
        
        // Find all anchor entities
        arView.scene.anchors.forEach { anchor in
            // Check all children of anchors
            findEntitiesRecursively(in: anchor).forEach { entity in
                // Calculate distance between entity and position
                let entityPosition = entity.position(relativeTo: nil)
                let distance = simd_distance(entityPosition, position)
                
                // Keep track of closest entity
                if distance < closestDistance {
                    closestDistance = distance
                    closestEntity = entity
                }
            }
        }
        
        return closestEntity
    }
    
    /**
     Recursively finds all entities in a parent entity.
     
     - Parameter parent: The parent entity to search
     - Returns: An array of all child entities
     */
    private func findEntitiesRecursively(in parent: Entity) -> [Entity] {
        var entities: [Entity] = []
        
        // Add parent
        entities.append(parent)
        
        // Add all children recursively
        for child in parent.children {
            entities.append(contentsOf: findEntitiesRecursively(in: child))
        }
        
        return entities
    }
    
    // MARK: - Button Actions
    
    /**
     Handles back button taps.
     */
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    /**
     Handles info button taps to show/hide the info panel.
     */
    @objc private func infoButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.infoPanel.isHidden.toggle()
        }
    }
    
    /**
     Handles capture button taps to take screenshots.
     */
    @objc private func captureButtonTapped() {
        // Hide info panel for screenshot
        let infoPanelWasVisible = !infoPanel.isHidden
        infoPanel.isHidden = true
        
        // Take screenshot
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Restore info panel visibility
        infoPanel.isHidden = !infoPanelWasVisible
        
        // Save image to photo library
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    /**
     Callback for image saving completion.
     */
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(
                title: "Save Error",
                message: "Failed to save screenshot: \(error.localizedDescription)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            // Show success feedback
            let successIndicator = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            successIndicator.tintColor = .white
            successIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            successIndicator.layer.cornerRadius = 40
            successIndicator.contentMode = .center
            successIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            successIndicator.center = view.center
            view.addSubview(successIndicator)
            
            // Animate success indicator
            successIndicator.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                successIndicator.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                    successIndicator.alpha = 0
                }) { _ in
                    successIndicator.removeFromSuperview()
                }
            }
        }
    }
    
    /**
     Handles favorite button taps to add/remove from favorites.
     */
    @objc private func favoriteButtonTapped() {
        guard let modelInfo = modelInfo else { return }
        
        // Toggle favorite status
        let isFavorite = FavoritesManager.shared.toggleFavorite(id: modelInfo.id, info: modelInfo)
        
        // Update button appearance
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    /**
     Updates the favorite button appearance based on favorite status.
     
     - Parameter isFavorite: Whether the current model is favorited
     */
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .white
    }
}

/**
 Model representing information about a heritage site or wildlife.
 */
struct ModelInformation: Codable {
    let id: String
    let name: String
    let type: ModelType
    let description: String
    let location: String?
    let coordinates: Coordinates?
    
    enum ModelType: String, Codable {
        case heritageSite
        case wildlife
    }
    
    struct Coordinates: Codable {
        let latitude: Double
        let longitude: Double
    }
}

/**
 Service responsible for loading models from various sources.
 */
class ModelLoader {
    /**
     Loads a model by name.
     
     - Parameter named: The name of the model to load
     - Returns: A publisher that emits the loaded model or an error
     */
    static func loadModel(named modelName: String) -> AnyPublisher<Entity, Error> {
        return Future<Entity, Error> { promise in
            // First try to load from local storage (for offline use)
            if let localModel = loadModelFromLocalStorage(named: modelName) {
                promise(.success(localModel))
                return
            }
            
            // If not available locally, load from bundle
            if let bundleURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
                do {
                    let entity = try Entity.load(contentsOf: bundleURL)
                    
                    // Save model for offline use
                    saveModelToLocalStorage(entity, named: modelName)
                    
                    promise(.success(entity))
                } catch {
                    promise(.failure(error))
                }
                return
            }
            
            // If not available in bundle, use a placeholder
            if let placeholderURL = Bundle.main.url(forResource: "placeholderModel", withExtension: "usdz") {
                do {
                    let entity = try Entity.load(contentsOf: placeholderURL)
                    promise(.success(entity))
                } catch {
                    promise(.failure(error))
                }
                return
            }
            
            // If all else fails, create a simple box
            let box = ModelEntity(mesh: .generateBox(size: 0.1))
            box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            promise(.success(box))
        }
        .eraseToAnyPublisher()
    }
    
    /**
     Loads a model from local storage.
     
     - Parameter named: The name of the model to load
     - Returns: The loaded model entity or nil if not found
     */
    private static func loadModelFromLocalStorage(named modelName: String) -> Entity? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let modelURL = documentsDirectory.appendingPathComponent("\(modelName).usdz")
        
        if fileManager.fileExists(atPath: modelURL.path) {
            do {
                return try Entity.load(contentsOf: modelURL)
            } catch {
                print("Error loading model from local storage: \(error)")
                return nil
            }
        }
        
        return nil
    }
    
    /**
     Saves a model to local storage for offline use.
     
     - Parameters:
        - entity: The entity to save
        - named: The name to save the model as
     */
    private static func saveModelToLocalStorage(_ entity: Entity, named modelName: String) {
        // Implementation would depend on RealityKit's export capabilities
        // This is a placeholder as direct export functionality is limited
        print("Saving model to local storage: \(modelName)")
    }
}

/**
 Manager for handling user favorites.
 */
class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "userFavorites"
    private var favorites: [String: ModelInformation] = [:]
    
    private init() {
        loadFavorites()
    }
    
    /**
     Loads favorites from UserDefaults.
     */
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([String: ModelInformation].self, from: data) {
            favorites = decoded
        }
    }
    
    /**
     Saves favorites to UserDefaults.
     */
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    /**
     Checks if a model is favorited.
     
     - Parameter id: The ID of the model to check
     - Returns: Whether the model is favorited
     */
    func isFavorite(id: String) -> Bool {
        return favorites[id] != nil
    }
    
    /**
     Toggles the favorite status of a model.
     
     - Parameters:
        - id: The ID of the model
        - info: The model information
     - Returns: The new favorite status
     */
    func toggleFavorite(id: String, info: ModelInformation) -> Bool {
        if isFavorite(id: id) {
            favorites.removeValue(forKey: id)
            saveFavorites()
            return false
        } else {
            favorites[id] = info
            saveFavorites()
            return true
        }
    }
}

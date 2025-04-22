//
//  MapViewScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - MapViewScreen
/// A view controller that displays heritage sites and wildlife locations on a map
class MapViewScreen: UIViewController {
    
    // MARK: - Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation?
    private let filterSegmentControl = UISegmentedControl(items: ["All", "Heritage", "Wildlife"])
    private let searchBar = UISearchBar()
    private let listViewButton = UIButton(type: .system)
    
    // Sample data - Would be replaced with actual data models in a complete implementation
    private var heritageLocations: [HeritageLocation] = []
    private var wildlifeLocations: [WildlifeLocation] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMapView()
        setupFilterSegmentControl()
        setupSearchBar()
        setupListViewButton()
        setupLayoutConstraints()
        
        // Configure location manager and request permissions
        configureLocationManager()
        
        // Load and display location data
        loadLocationData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start updating location when view appears
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop updating location when view disappears to save battery
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the navigation bar with title and appearance
    private func setupNavigationBar() {
        title = "Explore Map"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add right navigation item for settings/filters
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showFilterOptions))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    /// Sets up the main map view with appropriate settings
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register custom annotation views
        mapView.register(HeritageAnnotationView.self, forAnnotationViewWithReuseIdentifier: HeritageAnnotationView.reuseIdentifier)
        mapView.register(WildlifeAnnotationView.self, forAnnotationViewWithReuseIdentifier: WildlifeAnnotationView.reuseIdentifier)
        
        view.addSubview(mapView)
    }
    
    /// Sets up the segment control for filtering map items
    private func setupFilterSegmentControl() {
        filterSegmentControl.selectedSegmentIndex = 0
        filterSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        filterSegmentControl.addTarget(self, action: #selector(filterSelectionChanged), for: .valueChanged)
        
        // Style the segment control
        filterSegmentControl.backgroundColor = .systemBackground
        filterSegmentControl.layer.cornerRadius = 8
        filterSegmentControl.layer.masksToBounds = true
        
        view.addSubview(filterSegmentControl)
    }
    
    /// Sets up the search bar for location search
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search places..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        
        view.addSubview(searchBar)
    }
    
    /// Sets up button to toggle between map and list views
    private func setupListViewButton() {
        listViewButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listViewButton.backgroundColor = .systemBackground
        listViewButton.tintColor = .systemBlue
        listViewButton.layer.cornerRadius = 25
        listViewButton.layer.shadowColor = UIColor.black.cgColor
        listViewButton.layer.shadowOpacity = 0.3
        listViewButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        listViewButton.layer.shadowRadius = 4
        listViewButton.translatesAutoresizingMaskIntoConstraints = false
        listViewButton.addTarget(self, action: #selector(toggleListView), for: .touchUpInside)
        
        view.addSubview(listViewButton)
    }
    
    /// Sets up the auto layout constraints for all UI elements
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            // Map view constraints
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Search bar constraints - at the top of the map
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Filter segment control constraints - below search bar
            filterSegmentControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // List view button constraints - bottom right
            listViewButton.widthAnchor.constraint(equalToConstant: 50),
            listViewButton.heightAnchor.constraint(equalToConstant: 50),
            listViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            listViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    /// Configures location manager and requests location permissions
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Data Loading Methods
    
    /// Loads location data from the data service
    private func loadLocationData() {
        // In a real implementation, this would fetch data from a service
        // For demo purposes, we'll create some sample data
        
        // Sample heritage locations
        heritageLocations = [
            HeritageLocation(name: "Sigiriya",
                            description: "Ancient rock fortress",
                            coordinate: CLLocationCoordinate2D(latitude: 7.9570, longitude: 80.7603),
                            image: UIImage(named: "sigiriya"),
                            type: .cultural),
            HeritageLocation(name: "Polonnaruwa",
                            description: "Ancient city",
                            coordinate: CLLocationCoordinate2D(latitude: 7.9403, longitude: 81.0188),
                            image: UIImage(named: "polonnaruwa"),
                            type: .cultural),
            HeritageLocation(name: "Anuradhapura",
                            description: "Sacred city",
                            coordinate: CLLocationCoordinate2D(latitude: 8.3114, longitude: 80.4037),
                            image: UIImage(named: "anuradhapura"),
                            type: .cultural)
        ]
        
        // Sample wildlife locations
        wildlifeLocations = [
            WildlifeLocation(name: "Yala National Park",
                            description: "Home to leopards and elephants",
                            coordinate: CLLocationCoordinate2D(latitude: 6.3736, longitude: 81.5047),
                            image: UIImage(named: "yala"),
                            type: .nationalPark),
            WildlifeLocation(name: "Udawalawe National Park",
                            description: "Elephant sanctuary",
                            coordinate: CLLocationCoordinate2D(latitude: 6.4364, longitude: 80.8912),
                            image: UIImage(named: "udawalawe"),
                            type: .nationalPark),
            WildlifeLocation(name: "Sinharaja Forest Reserve",
                            description: "Rainforest biodiversity",
                            coordinate: CLLocationCoordinate2D(latitude: 6.4000, longitude: 80.6333),
                            image: UIImage(named: "sinharaja"),
                            type: .forestReserve)
        ]
        
        // Add annotations to map
        updateMapAnnotations()
    }
    
    /// Updates the map with annotations based on the current filter
    private func updateMapAnnotations() {
        // Remove all existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add annotations based on filter selection
        switch filterSegmentControl.selectedSegmentIndex {
        case 0: // All
            for location in heritageLocations {
                mapView.addAnnotation(location)
            }
            for location in wildlifeLocations {
                mapView.addAnnotation(location)
            }
        case 1: // Heritage
            for location in heritageLocations {
                mapView.addAnnotation(location)
            }
        case 2: // Wildlife
            for location in wildlifeLocations {
                mapView.addAnnotation(location)
            }
        default:
            break
        }
        
        // If we have locations, zoom to show all of them
        if let firstLocation = heritageLocations.first?.coordinate {
            let region = MKCoordinateRegion(center: firstLocation, latitudinalMeters: 300000, longitudinalMeters: 300000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Action Methods
    
    /// Shows filter options dialog
    @objc private func showFilterOptions() {
        let alertController = UIAlertController(title: "Map Options", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Show Traffic", style: .default) { _ in
            self.mapView.showsTraffic = !self.mapView.showsTraffic
        })
        
        alertController.addAction(UIAlertAction(title: "Satellite View", style: .default) { _ in
            self.mapView.mapType = self.mapView.mapType == .standard ? .satellite : .standard
        })
        
        alertController.addAction(UIAlertAction(title: "Center on My Location", style: .default) { _ in
            if let userLocation = self.mapView.userLocation.location {
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the controller
        present(alertController, animated: true)
    }
    
    /// Handles filter segment control value changes
    @objc private func filterSelectionChanged() {
        updateMapAnnotations()
    }
    
    /// Toggles between map and list view
    @objc private func toggleListView() {
        // In a real implementation, this would navigate to a list view controller
        // For demo purposes, we'll just print a message
        print("Toggle to list view")
        
        // Example of navigating to a list view:
        // let listViewController = LocationListViewController()
        // listViewController.heritageLocations = heritageLocations
        // listViewController.wildlifeLocations = wildlifeLocations
        // navigationController?.pushViewController(listViewController, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewScreen: MKMapViewDelegate {
    /// Configures annotation views when they are displayed on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't customize the user location annotation
        if annotation is MKUserLocation {
            return nil
        }
        
        // Handle heritage location annotations
        if let heritageAnnotation = annotation as? HeritageLocation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeritageAnnotationView.reuseIdentifier, for: heritageAnnotation) as! HeritageAnnotationView
            annotationView.configure(with: heritageAnnotation)
            return annotationView
        }
        
        // Handle wildlife location annotations
        if let wildlifeAnnotation = annotation as? WildlifeLocation {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: WildlifeAnnotationView.reuseIdentifier, for: wildlifeAnnotation) as! WildlifeAnnotationView
            annotationView.configure(with: wildlifeAnnotation)
            return annotationView
        }
        
        return nil
    }
    
    /// Handles tap events on map annotations
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        // In a real implementation, this would navigate to a detail view
        if let heritageLocation = annotation as? HeritageLocation {
            showLocationDetail(for: heritageLocation)
        } else if let wildlifeLocation = annotation as? WildlifeLocation {
            showLocationDetail(for: wildlifeLocation)
        }
    }
    
    /// Shows the detail view for a selected location
    private func showLocationDetail<T>(for location: T) {
        // This method would navigate to the appropriate detail view
        // For demo purposes, we'll just print the location name
        
        if let heritage = location as? HeritageLocation {
            print("Selected heritage site: \(heritage.name)")
            // Navigate to detail view:
            // let detailVC = SiteDetailViewController(heritage: heritage)
            // navigationController?.pushViewController(detailVC, animated: true)
        } else if let wildlife = location as? WildlifeLocation {
            print("Selected wildlife site: \(wildlife.name)")
            // Navigate to detail view:
            // let detailVC = WildlifeDetailViewController(wildlife: wildlife)
            // navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension MapViewScreen: UISearchBarDelegate {
    /// Handles search button clicks
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // Search for locations matching the search text
        performSearch(searchText: searchText)
    }
    
    /// Performs a search for locations matching the search text
    private func performSearch(searchText: String) {
        // In a real implementation, this would filter locations or use geocoding
        // For demo purposes, we'll just filter our existing locations
        
        let filteredHeritageLocations = heritageLocations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        let filteredWildlifeLocations = wildlifeLocations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        if filteredHeritageLocations.isEmpty && filteredWildlifeLocations.isEmpty {
            // Show "no results" message
            let alert = UIAlertController(title: "No Results", message: "No locations found matching '\(searchText)'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            // Remove existing annotations and add filtered ones
            mapView.removeAnnotations(mapView.annotations)
            
            for location in filteredHeritageLocations {
                mapView.addAnnotation(location)
            }
            
            for location in filteredWildlifeLocations {
                mapView.addAnnotation(location)
            }
            
            // Zoom to show all filtered annotations
            if let firstLocation = (filteredHeritageLocations + filteredWildlifeLocations).first?.coordinate {
                let region = MKCoordinateRegion(center: firstLocation, latitudinalMeters: 50000, longitudinalMeters: 50000)
                mapView.setRegion(region, animated: true)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewScreen: CLLocationManagerDelegate {
    /// Called when location manager updates the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentUserLocation = location
        
        // If we don't have any locations yet, zoom to the user's location
        if heritageLocations.isEmpty && wildlifeLocations.isEmpty {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    /// Called when the location manager fails to update location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        // Show an alert to the user
        let alert = UIAlertController(title: "Location Error", message: "Unable to determine your location. Please check your location settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Models

/// Model representing a heritage location
class HeritageLocation: NSObject, MKAnnotation {
    enum HeritageType {
        case cultural
        case religious
        case historical
    }
    
    let name: String
    let locationDescription: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let type: HeritageType
    
    var title: String? { return name }
    var subtitle: String? { return locationDescription }
    
    init(name: String, description: String, coordinate: CLLocationCoordinate2D, image: UIImage?, type: HeritageType) {
        self.name = name
        self.locationDescription = description
        self.coordinate = coordinate
        self.image = image
        self.type = type
        super.init()
    }
}

/// Model representing a wildlife location
class WildlifeLocation: NSObject, MKAnnotation {
    enum WildlifeType {
        case nationalPark
        case birdSanctuary
        case forestReserve
    }
    
    let name: String
    let locationDescription: String
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let type: WildlifeType
    
    var title: String? { return name }
    var subtitle: String? { return locationDescription }
    
    init(name: String, description: String, coordinate: CLLocationCoordinate2D, image: UIImage?, type: WildlifeType) {
        self.name = name
        self.locationDescription = description
        self.coordinate = coordinate
        self.image = image
        self.type = type
        super.init()
    }
}

// MARK: - Custom Annotation Views

/// Custom annotation view for heritage locations
class HeritageAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "HeritageAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        canShowCallout = true
        markerTintColor = .systemOrange
        glyphImage = UIImage(systemName: "building.columns")
        
        // Add a button to the right side of the callout
        let button = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = button
        
        // Add an image view to the left side of the callout
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        leftCalloutAccessoryView = imageView
    }
    
    func configure(with location: HeritageLocation) {
        // Set the callout image
        if let imageView = leftCalloutAccessoryView as? UIImageView {
            imageView.image = location.image
        }
        
        // Set the glyph based on the type
        switch location.type {
        case .cultural:
            glyphImage = UIImage(systemName: "building.columns")
        case .religious:
            glyphImage = UIImage(systemName: "building.2")
        case .historical:
            glyphImage = UIImage(systemName: "flag")
        }
    }
}

/// Custom annotation view for wildlife locations
class WildlifeAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "WildlifeAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        canShowCallout = true
        markerTintColor = .systemGreen
        glyphImage = UIImage(systemName: "leaf")
        
        // Add a button to the right side of the callout
        let button = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = button
        
        // Add an image view to the left side of the callout
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        leftCalloutAccessoryView = imageView
    }
    
    func configure(with location: WildlifeLocation) {
        // Set the callout image
        if let imageView = leftCalloutAccessoryView as? UIImageView {
            imageView.image = location.image
        }
        
        // Set the glyph based on the type
        switch location.type {
        case .nationalPark:
            glyphImage = UIImage(systemName: "leaf")
        case .birdSanctuary:
            glyphImage = UIImage(systemName: "bird")
        case .forestReserve:
            glyphImage = UIImage(systemName: "tree")
        }
    }
}

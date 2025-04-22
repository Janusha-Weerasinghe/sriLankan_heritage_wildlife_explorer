//
//  LocationManager.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import Foundation
import CoreLocation
import Combine

/// Manages location services throughout the app
class LocationManager: NSObject, ObservableObject {
    // MARK: - Published Properties
    
    /// Current user location
    @Published var location: CLLocation?
    
    /// Current user location authorization status
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Error message
    @Published var errorMessage: String?
    
    /// Distance to the nearest heritage site (in meters)
    @Published var nearestHeritageSiteDistance: Double?
    
    /// Distance to the nearest wildlife spot (in meters)
    @Published var nearestWildlifeSpotDistance: Double?
    
    /// Indicates if location services are available
    @Published var locationServicesEnabled = false
    
    // MARK: - Private Properties
    
    /// Core Location manager
    private let locationManager = CLLocationManager()
    
    /// Locations of heritage sites
    private var heritageSites: [SiteLocation] = []
    
    /// Locations of wildlife spots
    private var wildlifeSpots: [SiteLocation] = []
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters moved
        
        // Check location services status
        checkLocationServicesStatus()
        
        // Load data
        loadSampleData()
    }
    
    // MARK: - Public Methods
    
    /// Request location permissions
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Start location updates
    func startLocationUpdates() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            errorMessage = "Location services are disabled"
        }
    }
    
    /// Stop location updates
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Get nearby heritage sites
    /// - Parameter radius: Distance in meters
    /// - Returns: Array of nearby sites
    func getNearbyHeritageSites(withinRadius radius: Double) -> [SiteLocation] {
        guard let userLocation = location else { return [] }
        
        return heritageSites.filter { site in
            let siteLocation = CLLocation(latitude: site.latitude, longitude: site.longitude)
            let distance = userLocation.distance(from: siteLocation)
            return distance <= radius
        }
    }
    
    /// Get nearby wildlife spots
    /// - Parameter radius: Distance in meters
    /// - Returns: Array of nearby wildlife spots
    func getNearbyWildlifeSpots(withinRadius radius: Double) -> [SiteLocation] {
        guard let userLocation = location else { return [] }
        
        return wildlifeSpots.filter { spot in
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let distance = userLocation.distance(from: spotLocation)
            return distance <= radius
        }
    }
    
    /// Get distance to a specific site
    /// - Parameter site: Site location
    /// - Returns: Distance in meters or nil if no user location
    func distanceTo(site: SiteLocation) -> Double? {
        guard let userLocation = location else { return nil }
        
        let siteLocation = CLLocation(latitude: site.latitude, longitude: site.longitude)
        return userLocation.distance(from: siteLocation)
    }
    
    /// Get direction to a specific site
    /// - Parameter site: Site location
    /// - Returns: Direction in degrees or nil if no user location
    func directionTo(site: SiteLocation) -> Double? {
        guard let userLocation = location else { return nil }
        
        let lat1 = userLocation.coordinate.latitude.radians
        let lon1 = userLocation.coordinate.longitude.radians
        let lat2 = site.latitude.radians
        let lon2 = site.longitude.radians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return (radiansBearing.degrees + 360).truncatingRemainder(dividingBy: 360)
    }
    
    // MARK: - Private Methods
    
    /// Check if location services are enabled
    private func checkLocationServicesStatus() {
        if CLLocationManager.locationServicesEnabled() {
            locationServicesEnabled = true
            authorizationStatus = locationManager.authorizationStatus
        } else {
            locationServicesEnabled = false
            errorMessage = "Location services are disabled"
        }
    }
    
    /// Load sample location data
    private func loadSampleData() {
        // Sample heritage sites in Sri Lanka
        heritageSites = [
            SiteLocation(id: "sigiriya", name: "Sigiriya", latitude: 7.9572, longitude: 80.7603, type: .heritage),
            SiteLocation(id: "polonnaruwa", name: "Polonnaruwa", latitude: 7.9403, longitude: 81.0188, type: .heritage),
            SiteLocation(id: "anuradhapura", name: "Anuradhapura", latitude: 8.3114, longitude: 80.4037, type: .heritage),
            SiteLocation(id: "dambulla", name: "Dambulla Cave Temple", latitude: 7.8568, longitude: 80.6501, type: .heritage),
            SiteLocation(id: "kandy", name: "Temple of the Tooth", latitude: 7.2936, longitude: 80.6413, type: .heritage)
        ]
        
        // Sample wildlife spots in Sri Lanka
        wildlifeSpots = [
            SiteLocation(id: "yala", name: "Yala National Park", latitude: 6.3698, longitude: 81.5046, type: .wildlife),
            SiteLocation(id: "wilpattu", name: "Wilpattu National Park", latitude: 8.4550, longitude: 80.0484, type: .wildlife),
            SiteLocation(id: "udawalawe", name: "Udawalawe National Park", latitude: 6.4389, longitude: 80.8983, type: .wildlife),
            SiteLocation(id: "minneriya", name: "Minneriya National Park", latitude: 8.0344, longitude: 80.9013, type: .wildlife),
            SiteLocation(id: "sinharaja", name: "Sinharaja Forest Reserve", latitude: 6.4095, longitude: 80.4184, type: .wildlife)
        ]
    }
    
    /// Update nearest site distances
    private func updateNearestSiteDistances() {
        guard let userLocation = location else {
            nearestHeritageSiteDistance = nil
            nearestWildlifeSpotDistance = nil
            return
        }
        
        // Find nearest heritage site
        if let nearestHeritageSite = heritageSites.min(by: { site1, site2 in
            let location1 = CLLocation(latitude: site1.latitude, longitude: site1.longitude)
            let location2 = CLLocation(latitude: site2.latitude, longitude: site2.longitude)
            return userLocation.distance(from: location1) < userLocation.distance(from: location2)
        }) {
            let siteLocation = CLLocation(latitude: nearestHeritageSite.latitude, longitude: nearestHeritageSite.longitude)
            nearestHeritageSiteDistance = userLocation.distance(from: siteLocation)
        }
        
        // Find nearest wildlife spot
        if let nearestWildlifeSpot = wildlifeSpots.min(by: { spot1, spot2 in
            let location1 = CLLocation(latitude: spot1.latitude, longitude: spot1.longitude)
            let location2 = CLLocation(latitude: spot2.latitude, longitude: spot2.longitude)
            return userLocation.distance(from: location1) < userLocation.distance(from: location2)
        }) {
            let spotLocation = CLLocation(latitude: nearestWildlifeSpot.latitude, longitude: nearestWildlifeSpot.longitude)
            nearestWildlifeSpotDistance = userLocation.distance(from: spotLocation)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            updateNearestSiteDistances()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            errorMessage = "Location access denied"
            stopLocationUpdates()
        case .notDetermined:
            // Wait for user response
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Supporting Types

/// Represents a location of interest in the app
struct SiteLocation: Identifiable, Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let type: SiteType
}

/// Types of sites in the app
enum SiteType: String, Codable {
    case heritage
    case wildlife
}

// MARK: - Utility Extensions

extension Double {
    var radians: Double {
        return self * .pi / 180
    }
    
    var degrees: Double {
        return self * 180 / .pi
    }
}

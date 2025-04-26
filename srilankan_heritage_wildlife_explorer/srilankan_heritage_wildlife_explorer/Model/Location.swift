//
//  Location.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-25.
//

import Foundation
import MapKit

// Renaming to avoid ambiguity
struct LocationModel: Identifiable {
    let id = UUID()
    var name: String
    var category: LocationCategory
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum LocationCategory: String, CaseIterable {
        case sanctuary = "Sanctuary"
        case park = "Park"
        case birdWatching = "Bird Watching"
        case lodge = "Wildlife Lodge"
    }
}

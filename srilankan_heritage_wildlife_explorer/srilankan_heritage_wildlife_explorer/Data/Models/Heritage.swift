//
//  Heritage.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import Foundation
import SwiftUI

// MARK: - Models
/// Model representing a heritage site
struct HeritageSite: Identifiable {
    let id = UUID()
    let name: String
    let shortDescription: String
    let fullDescription: String
    let imageName: String
    let thumbnailImage: String
    let images: [String]
    let location: String
    let coordinates: (latitude: Double, longitude: Double)
    let distance: Double?
    let historicalPeriod: String
    let yearBuilt: String
    let culturalSignificance: String
    let hasARExperience: Bool
    let isFavorite: Bool
    
    // Computed property to format distance
    var formattedDistance: String {
        if let distance = distance {
            return "\(Int(distance)) km"
        }
        return "Unknown"
    }
}

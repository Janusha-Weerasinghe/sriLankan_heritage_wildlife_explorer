//
//  Untitled.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import Foundation
import CoreLocation

struct HeritageItem: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let shortDescription: String
    let imageURL: String
    let arAvailable: Bool
    let arModelName: String?
    let location: LocationCoordinate
    let category: ItemCategory
    
    enum ItemCategory: String, Codable {
        case heritage
        case wildlife
    }
}

struct LocationCoordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var clLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

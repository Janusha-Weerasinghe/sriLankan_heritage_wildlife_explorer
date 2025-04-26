//
//  Untitled.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import Foundation

struct WildlifeItem: Identifiable, Codable {
    let id: String
    let name: String
    let scientificName: String
    let description: String
    let shortDescription: String
    let imageURL: String
    let arAvailable: Bool
    let arModelName: String?
    let status: ConservationStatus
    let population: String
    let habitat: String
    let commonLocations: [String]
    
    enum ConservationStatus: String, Codable {
        case endangered = "Endangered"
        case vulnerable = "Vulnerable"
        case nearThreatened = "Near Threatened"
        case leastConcern = "Least Concern"
    }
}

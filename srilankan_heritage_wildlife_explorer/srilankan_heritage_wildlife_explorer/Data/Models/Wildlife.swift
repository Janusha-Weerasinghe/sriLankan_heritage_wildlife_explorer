//////
//////  Wildlife.swift
//////  srilankan_heritage_wildlife_explorer
//////
//////  Created by Janusha 023 on 2025-04-22.
//////
////
////import Foundation
////
/////// Model representing wildlife species
////struct Wildlife: Identifiable, Codable, Equatable {
////    let id: UUID
////    let name: String
////    let scientificName: String
////    let category: WildlifeCategory
////    let conservationStatus: ConservationStatus
////    let shortDescription: String
////    let fullDescription: String
////    let habitat: String
////    let conservationEfforts: String
////    let dietType: String
////    let lifespan: String
////    let imageName: String
////    var isFavorite: Bool
////    
////    /// Image paths for the gallery section
////    let galleryImageNames: [String]
////    
////    /// Locations where this species can be found in Sri Lanka
////    let locations: [WildlifeLocation]
////    
////    /// Fun facts about the species
////    let funFacts: [String]
////    
////    /// Returns whether this species is endangered
////    var isEndangered: Bool {
////        return conservationStatus == .endangered || conservationStatus == .criticallyEndangered
////    }
////    
////    /// Initializes a new wildlife species
////    init(
////        id: UUID = UUID(),
////        name: String,
////        scientificName: String,
////        category: WildlifeCategory,
////        conservationStatus: ConservationStatus,
////        shortDescription: String,
////        fullDescription: String,
////        habitat: String = "",
////        conservationEfforts: String = "",
////        dietType: String = "",
////        lifespan: String = "",
////        imageName: String,
////        isFavorite: Bool = false,
////        galleryImageNames: [String] = [],
////        locations: [WildlifeLocation] = [],
////        funFacts: [String] = []
////    ) {
////        self.id = id
////        self.name = name
////        self.scientificName = scientificName
////        self.category = category
////        self.conservationStatus = conservationStatus
////        self.shortDescription = shortDescription
////        self.fullDescription = fullDescription
////        self.habitat = habitat
////        self.conservationEfforts = conservationEfforts
////        self.dietType = dietType
////        self.lifespan = lifespan
////        self.imageName = imageName
////        self.isFavorite = isFavorite
////        self.galleryImageNames = galleryImageNames
////        self.locations = locations
////        self.funFacts = funFacts
////    }
////    
////    static func == (lhs: Wildlife, rhs: Wildlife) -> Bool {
////        return lhs.id == rhs.id
////    }
////}
////
/////// Categories of wildlife
////enum WildlifeCategory: String, Codable, CaseIterable {
////    case mammals = "Mammals"
////    case birds = "Birds"
////    case reptiles = "Reptiles"
////    case amphibians = "Amphibians"
////    case fish = "Fish"
////    case insects = "Insects"
////    case other = "Other"
////    
////    static var displayCategories: [String] {
////        return ["All"] + Self.allCases.map { $0.rawValue }
////    }
////}
////
/////// Conservation status categories
////enum ConservationStatus: String, Codable, CaseIterable {
////    case extinct = "Extinct"
////    case extirpated = "Extirpated"
////    case criticallyEndangered = "Critically Endangered"
////    case endangered = "Endangered"
////    case vulnerable = "Vulnerable"
////    case threatened = "Threatened"
////    case nearThreatened = "Near Threatened"
////    case leastConcern = "Least Concern"
////    case dataDeficient = "Data Deficient"
////    
////    var color: String {
////        switch self {
////        case .extinct, .extirpated, .criticallyEndangered:
////            return "StatusCritical"
////        case .endangered:
////            return "StatusEndangered"
////        case .vulnerable, .threatened:
////            return "StatusVulnerable"
////        case .nearThreatened:
////            return "StatusNearThreatened"
////        case .leastConcern:
////            return "StatusLeastConcern"
////        case .dataDeficient:
////            return "StatusUnknown"
////        }
////    }
////}
////
/////// Geographic location where wildlife can be found
////struct WildlifeLocation: Identifiable, Codable, Equatable {
////    let id: UUID
////    let name: String
////    let description: String
////    let latitude: Double
////    let longitude: Double
////    let bestTimeToVisit: String
////    
////    init(
////        id: UUID = UUID(),
////        name: String,
////        description: String,
////        latitude: Double,
////        longitude: Double,
////        bestTimeToVisit: String = ""
////    ) {
////        self.id = id
////        self.name = name
////        self.description = description
////        self.latitude = latitude
////        self.longitude = longitude
////        self.bestTimeToVisit = bestTimeToVisit
////    }
////    
////    static func == (lhs: WildlifeLocation, rhs: WildlifeLocation) -> Bool {
////        return lhs.id == rhs.id
////    }
////}
//
///// Model representing a wildlife species
//struct Wildlife: Identifiable {
//    let id = UUID()
//    let name: String
//    let scientificName: String
//    let category: String
//    let conservationStatus: String
//    let shortDescription: String
//    let fullDescription: String
//    let imageName: String
//    let thumbnailImage: String
//    let images: [String]
//    let location: String
//    let coordinates: (latitude: Double, longitude: Double)
//    let habitat: String
//    let diet: String
//    let lifespan: String
//    let isFavorite: Bool
//    let hasARExperience: Bool
//    
//    // Computed property to format conservation status with color
//    var statusColor: Color {
//        switch conservationStatus.lowercased() {
//            case "endangered": return .red
//            case "vulnerable": return .orange
//            case "near threatened": return .yellow
//            case "least concern": return .green
//            default: return .gray
//        }
//    }
//}

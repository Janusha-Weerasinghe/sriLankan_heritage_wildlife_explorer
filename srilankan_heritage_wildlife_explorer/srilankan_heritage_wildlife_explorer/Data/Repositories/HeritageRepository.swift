//
//  HeritageRepository.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import Foundation

class HeritageRepository {
    // Singleton instance
    static let shared = HeritageRepository()
    
    // Sample data for heritage sites
    func getAllHeritageSites() -> [HeritageSite] {
        return [
            HeritageSite(
                name: "Sigiriya",
                shortDescription: "Ancient rock fortress with frescoes",
                fullDescription: "Sigiriya, also known as the Lion Rock, is an ancient rock fortress and palace ruin situated in the central Matale District of Sri Lanka. It is surrounded by the remains of an extensive network of gardens, reservoirs, and other structures. It was built by King Kassapa I and served as his new capital.",
                imageName: "sigiriya",
                thumbnailImage: "sigiriya_thumb",
                images: ["sigiriya_1", "sigiriya_2", "sigiriya_3"],
                location: "Central Province",
                coordinates: (latitude: 7.9570, longitude: 80.7603),
                distance: 120,
                historicalPeriod: "5th Century CE",
                yearBuilt: "477-495 CE",
                culturalSignificance: "UNESCO World Heritage Site since 1982",
                hasARExperience: true,
                isFavorite: true
            ),
            HeritageSite(
                name: "Polonnaruwa",
                shortDescription: "Medieval capital & UNESCO site",
                fullDescription: "Polonnaruwa is the second most ancient of Sri Lanka's kingdoms. It was first declared the capital city by King Vijayabahu I, who defeated Chola invaders in 1070 CE to reunite the country once more under a local leader.",
                imageName: "polonnaruwa",
                thumbnailImage: "polonnaruwa_thumb",
                images: ["polonnaruwa_1", "polonnaruwa_2", "polonnaruwa_3"],
                location: "North Central",
                coordinates: (latitude: 7.9403, longitude: 81.0188),
                distance: 215,
                historicalPeriod: "Medieval Period",
                yearBuilt: "11th Century CE",
                culturalSignificance: "UNESCO World Heritage Site since 1982",
                hasARExperience: true,
                isFavorite: false
            ),
            HeritageSite(
                name: "Anuradhapura",
                shortDescription: "Sacred ancient city",
                fullDescription: "Anuradhapura is one of the ancient capitals of Sri Lanka, famous for its well-preserved ruins of an ancient Sri Lankan civilization. The city, now a UNESCO World Heritage Site, was the center of Theravada Buddhism for many centuries.",
                imageName: "anuradhapura",
                thumbnailImage: "anuradhapura_thumb",
                images: ["anuradhapura_1", "anuradhapura_2", "anuradhapura_3"],
                location: "North Central",
                coordinates: (latitude: 8.3114, longitude: 80.4037),
                distance: 240,
                historicalPeriod: "Ancient Period",
                yearBuilt: "4th Century BCE",
                culturalSignificance: "UNESCO World Heritage Site since 1982",
                hasARExperience: true,
                isFavorite: true
            ),
            HeritageSite(
                name: "Temple of the Tooth",
                shortDescription: "Sacred Buddhist temple",
                fullDescription: "Sri Dalada Maligawa or the Temple of the Sacred Tooth Relic is a Buddhist temple in the city of Kandy, Sri Lanka. It is located in the royal palace complex which houses the relic of the tooth of Buddha.",
                imageName: "temple_tooth",
                thumbnailImage: "temple_tooth_thumb",
                images: ["temple_tooth_1", "temple_tooth_2", "temple_tooth_3"],
                location: "Kandy",
                coordinates: (latitude: 7.2936, longitude: 80.6413),
                distance: 85,
                historicalPeriod: "Colonial Period",
                yearBuilt: "16th Century CE",
                culturalSignificance: "UNESCO World Heritage Site since 1988",
                hasARExperience: true,
                isFavorite: false
            ),
            HeritageSite(
                name: "Galle Fort",
                shortDescription: "Dutch colonial fortification",
                fullDescription: "Galle Fort, in the Bay of Galle on the southwest coast of Sri Lanka, was built first in 1588 by the Portuguese, then extensively fortified by the Dutch during the 17th century from 1649 onwards.",
                imageName: "galle_fort",
                thumbnailImage: "galle_fort_thumb",
                images: ["galle_fort_1", "galle_fort_2", "galle_fort_3"],
                location: "Southern Province",
                coordinates: (latitude: 6.0257, longitude: 80.2169),
                distance: 175,
                historicalPeriod: "Colonial Period",
                yearBuilt: "1588 CE",
                culturalSignificance: "UNESCO World Heritage Site since 1988",
                hasARExperience: true,
                isFavorite: true
            )
        ]
    }
    
    func getFeaturedSite() -> HeritageSite {
        return getAllHeritageSites()[0]
    }
}



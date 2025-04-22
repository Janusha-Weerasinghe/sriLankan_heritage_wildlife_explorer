//
//  Untitled.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//
import Foundation

/// Model representing a user profile
struct UserProfile: Identifiable {
    let id = UUID()
    var fullName: String
    var email: String
    var country: String
    var profileImageName: String?
    var visitedSites: [String] // IDs of visited heritage sites
    var favorites: [String] // IDs of favorite heritage sites and wildlife
    var completedTours: [String] // IDs of completed tours
    var achievements: [Achievement]
    var preferences: UserPreferences
    
    // Computed properties for statistics
    var visitedSitesCount: Int {
        return visitedSites.count
    }
    
    var favoritesCount: Int {
        return favorites.count
    }
    
    var completedToursCount: Int {
        return completedTours.count
    }
    
    // Achievement struct for user badges
    struct Achievement {
        let id: String
        let title: String
        let description: String
        let iconName: String
        let dateEarned: Date
        let progress: Double // 0.0 to 1.0
    }
    
    // User preferences struct
    struct UserPreferences {
        var notificationsEnabled: Bool
        var darkModeEnabled: Bool
        var languageCode: String
        var useMetricSystem: Bool
        var showOfflineMaps: Bool
        var autoPlayAudio: Bool
    }
}

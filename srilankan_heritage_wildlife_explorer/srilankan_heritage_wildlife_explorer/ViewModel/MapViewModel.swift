//
//  MapViewModel.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-25.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var selectedFilter: LocationModel.LocationCategory?  // Stores the selected filter
    @Published var locations: [LocationModel] = []  // List of all locations

    // Initialize the ViewModel with mock data
    init() {
        loadData()
    }

    // Loads mock data for wildlife locations
    private func loadData() {
        locations = [
            LocationModel(name: "Elephant Sanctuary", category: .sanctuary, latitude: 6.9271, longitude: 79.8612),
            LocationModel(name: "Safari Park", category: .park, latitude: 6.9267, longitude: 79.8610),
            LocationModel(name: "Bird Watching Spot", category: .birdWatching, latitude: 6.9260, longitude: 79.8600),
            LocationModel(name: "Wildlife Lodge", category: .lodge, latitude: 6.9275, longitude: 79.8615)
        ]
    }

    // Returns filtered locations based on the selected category
    func filteredLocations() -> [LocationModel] {
        guard let filter = selectedFilter else { return locations }
        return locations.filter { $0.category == filter }
    }

    // Toggles the selected category filter
    func toggleFilter(_ category: LocationModel.LocationCategory) {
        if selectedFilter == category {
            selectedFilter = nil  // If the selected category is the same, remove the filter
        } else {
            selectedFilter = category  // Otherwise, set the new filter
        }
    }
}

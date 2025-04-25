//
//  MapView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var selectedFilter: LocationModel.LocationCategory?
    @State private var showingDirections = false
    @State private var locations: [LocationModel] = [
        LocationModel(name: "Elephant Sanctuary", category: .sanctuary, latitude: 6.9271, longitude: 79.8612),
        LocationModel(name: "Safari Park", category: .park, latitude: 6.9267, longitude: 79.8610),
        LocationModel(name: "Bird Watching Spot", category: .birdWatching, latitude: 6.9260, longitude: 79.8600),
        LocationModel(name: "Wildlife Lodge", category: .lodge, latitude: 6.9275, longitude: 79.8615)
    ]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                showsUserLocation: true,
                annotationItems: filteredLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LocationAnnotationView(location: location)
                        .onTapGesture {
                            // Handle location tap
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(LocationModel.LocationCategory.allCases, id: \.self) { category in
                            FilterButton(
                                title: category.rawValue,
                                isSelected: selectedFilter == category,
                                action: { toggleFilter(category) }
                            )
                        }
                    }
                    .padding()
                }
                .background(Color.white.opacity(0.9))
                
                Spacer()
            }
            
            if let selectedLocation = locations.first { $0.name == "Elephant Sanctuary" } {
                VStack {
                    Spacer()
                    LocationDetailCard(location: selectedLocation) {
                        showingDirections = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingDirections) {
            if let selectedLocation = locations.first { $0.name == "Elephant Sanctuary" } {
                DirectionsView(destination: selectedLocation)
            }
        }
    }
    
    private var filteredLocations: [LocationModel] {
        guard let filter = selectedFilter else { return locations }
        return locations.filter { $0.category == filter }
    }
    
    private func toggleFilter(_ category: LocationModel.LocationCategory) {
        if selectedFilter == category {
            selectedFilter = nil
        } else {
            selectedFilter = category
        }
    }
}

struct FilterButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(isSelected ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct LocationDetailCard: View {
    var location: LocationModel
    var action: () -> Void

    var body: some View {
        VStack {
            Text(location.name)
                .font(.headline)
            Button(action: action) {
                Text("Get Directions")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

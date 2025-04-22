//
//  MapExplorerView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-22.
//

import SwiftUI
import MapKit

struct MapExplorerView: View {
    let sites: [HeritageSite]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Map Explorer")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            ZStack(alignment: .bottomTrailing) {
                // In a real implementation, this would use MapKit with actual coordinates
                Rectangle()
                    .fill(Color(UIColor.tertiarySystemBackground))
                    .frame(height: 180)
                    .cornerRadius(12)
                    .overlay(
                        Text("Interactive Map")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    )
                    .padding(.horizontal)
                
                // Navigate button
                Button(action: {
                    // Action to navigate to full map view
                }) {
                    Text("Open Full Map")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding()
            }
        }
    }
}

// In a real implementation, this would be a full map view
struct FullMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718), // Center of Sri Lanka
        span: MKCoordinateSpan(latitudeDelta: 3.0, longitudeDelta: 3.0)
    )
    
    let sites: [HeritageSite]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: sites) { site in
            MapAnnotation(coordinate: CLLocationCoordinate2D(
                latitude: site.coordinates.latitude,
                longitude: site.coordinates.longitude)
            ) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                    Text(site.name)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

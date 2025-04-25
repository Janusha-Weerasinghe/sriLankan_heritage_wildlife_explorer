//
//  DerectionView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-25.
//
import SwiftUI
import MapKit

struct DirectionsView: View {
    var destination: LocationModel

    var body: some View {
        VStack {
            Text("Directions to \(destination.name)")
                .font(.title2)
                .padding()

            Map(
                coordinateRegion: .constant(MKCoordinateRegion(
                    center: destination.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )),
                annotationItems: [destination]
            ) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

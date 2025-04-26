//
//  LocationAnnotationView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-25.
//
import SwiftUI

struct LocationAnnotationView: View {
    var location: LocationModel

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "leaf.circle.fill") // You can replace this icon based on category
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
            
            Text(location.name)
                .font(.caption2)
                .foregroundColor(.black)
                .padding(4)
                .background(Color.white)
                .cornerRadius(5)
        }
    }
}

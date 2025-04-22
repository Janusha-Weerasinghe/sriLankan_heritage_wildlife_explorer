//
//  WildlifeDetailScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI

// MARK: - Heritage Site Detail View
/// Detailed view for a heritage site


struct WildlifeDetailScreen: View {
    // MARK: - Properties
    let site: HeritageSite
    @Environment(\.presentationMode) var presentationMode
    @State private var showARExperience = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header image with back button
                ZStack(alignment: .topLeading) {
                    Image(site.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and location
                    VStack(alignment: .leading, spacing: 8) {
                        Text(site.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            
                            Text(site.location)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Built: \(site.yearBuilt)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(site.culturalSignificance)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            // Navigate action
                        }) {
                            Label("Navigate", systemImage: "map.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        if site.hasARExperience {
                            Button(action: {
                                showARExperience = true
                            }) {
                                Label("AR Experience", systemImage: "arkit")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.purple)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(site.fullDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        // Historical period
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Historical Period")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 12)
                            
                            Text(site.historicalPeriod)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Gallery - placeholder for actual implementation
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gallery")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 12)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(site.images, id: \.self) { imageName in
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 90)
                                            .cornerRadius(8)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showARExperience) {
            // AR Experience would be implemented using ARKit
            Text("AR Experience for \(site.name)")
                .font(.title)
                .padding()
        }
    }
}

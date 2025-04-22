//
//  FeaturedSiteView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-22.
//

import SwiftUI

struct FeaturedSiteView: View {
    let site: HeritageSite
    let onARButtonTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Site")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ZStack(alignment: .bottomLeading) {
                // Featured image
                Image(site.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                // AR Experience button
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(site.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if site.hasARExperience {
                            Button(action: onARButtonTapped) {
                                Label("AR", systemImage: "arkit")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    Text("Experience the \(site.name) in augmented reality")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.black.opacity(0.7), .black.opacity(0.2), .clear]
                        ),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }
}

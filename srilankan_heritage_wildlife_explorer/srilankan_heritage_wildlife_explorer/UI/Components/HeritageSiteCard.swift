//
//  HeritageSiteCard.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-22.
//

import SwiftUI

// MARK: - Heritage Site Card Component
/// Reusable card component for displaying heritage sites
struct HeritageSiteCard: View {
    // MARK: - Properties
    let site: HeritageSite
    let onTap: () -> Void
    @State private var isFavorite: Bool
    
    // MARK: - Initialization
    init(site: HeritageSite, onTap: @escaping () -> Void) {
        self.site = site
        self.onTap = onTap
        _isFavorite = State(initialValue: site.isFavorite)
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Image
                ZStack(alignment: .topTrailing) {
                    Image(site.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 120)
                        .clipped()
                        .cornerRadius(12)
                    
                    // Favorite button
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .font(.system(size: 18))
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
                
                // Site name
                Text(site.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Short description
                Text(site.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .frame(width: 160)
                
                // Location and distance
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                    
                    Text(site.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(site.formattedDistance)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 160)
            .padding(.bottom, 8)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

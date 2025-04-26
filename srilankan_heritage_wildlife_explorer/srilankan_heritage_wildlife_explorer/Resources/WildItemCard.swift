//
//  WildItemCard.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import SwiftUI

struct WildlifeItemCard: View {
    let item: WildlifeItem
    @EnvironmentObject var viewModel: HeritageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                }
                .frame(height: 200)
                .cornerRadius(12)
                .clipped()
                
                if item.arAvailable {
                    Button(action: {
                        viewModel.selectItem(item)
                        viewModel.showARViewForItem(item)
                    }) {
                        Text("AR Available")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(8)
                }
            }
            
            Text(item.name)
                .font(.headline)
                .padding(.top, 8)
            
            Text(item.shortDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            NavigationLink(destination: WildlifeDetailView(item: item)) {
                Text("See More")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

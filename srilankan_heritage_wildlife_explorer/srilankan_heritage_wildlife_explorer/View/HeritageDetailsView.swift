//
//  HeritageDetailsView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import SwiftUI

struct HeritageDetailView: View {
    let item: HeritageItem
    @EnvironmentObject var viewModel: HeritageViewModel
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Header Image
                AsyncImage(url: URL(string: item.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                }
                .frame(height: 300)
                .clipped()
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    
                    Divider()
                    
                    Text(item.description)
                        .font(.body)
                    
                    if let locations = item.location.clLocation.userFriendlyDescription() {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Common Locations")
                                .font(.headline)
                            
                            Text(locations)
                                .font(.subheadline)
                        }
                        .padding(.top, 8)
                    }
                    
                    // AR Button
                    if item.arAvailable {
                        Button(action: {
                            viewModel.selectItem(item)
                            viewModel.showARViewForItem(item)
                        }) {
                            HStack {
                                Text("View in AR")
                                    .fontWeight(.semibold)
                                Image(systemName: "arkit")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 16)
                    }
                    
                    // Siri Button
                    Button(action: {
                        // This would typically integrate with your SiriKit Intent handling
                    }) {
                        HStack {
                            Text("Voice Commands")
                                .fontWeight(.semibold)
                            Image(systemName: "waveform")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationBarTitle(item.name, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            // Share functionality
        }) {
            Image(systemName: "square.and.arrow.up")
        })
    }
}

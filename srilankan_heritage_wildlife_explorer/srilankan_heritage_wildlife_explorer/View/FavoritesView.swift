//
//  FavoritesView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//
import SwiftUI

// Favorites view to display saved heritage sites and wildlife
struct FavoritesView: View {
    @EnvironmentObject var viewModel: HeritageViewModel
    @State private var selectedTab = 0
    @State private var favorites: [String: Any] = [:]
    
    var body: some View {
        NavigationView {
            VStack {
                // Tab selector
                Picker("Category", selection: $selectedTab) {
                    Text("Heritage").tag(0)
                    Text("Wildlife").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedTab == 0 {
                    // Heritage favorites
                    if filteredHeritageItems.isEmpty {
                        EmptyFavoritesView(type: "heritage sites")
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(filteredHeritageItems) { item in
                                    HeritageItemCard(item: item)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    // Wildlife favorites
                    if filteredWildlifeItems.isEmpty {
                        EmptyFavoritesView(type: "wildlife")
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(filteredWildlifeItems) { item in
                                    WildlifeItemCard(item: item)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                loadFavorites()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var filteredHeritageItems: [HeritageItem] {
        // In a real app, this would filter heritage items based on saved favorites
        // For demo purposes, we'll return a subset of items
        return Array(viewModel.heritageItems.prefix(2))
    }
    
    private var filteredWildlifeItems: [WildlifeItem] {
        // Similar to above, this would filter based on saved favorites
        return Array(viewModel.wildlifeItems.prefix(2))
    }
    
    private func loadFavorites() {
        // In a real app, this would load favorites from UserDefaults or Core Data
        // For simplicity, we're using mock data
    }
}

// Empty state view for favorites
struct EmptyFavoritesView: View {
    let type: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
                .padding()
            
            Text("No Favorite \(type.capitalized) Yet")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Start exploring and add items to your favorites")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
// MARK: - Preview
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = HeritageViewModel()

        mockViewModel.heritageItems = [
            HeritageItem(
                id: "1",
                name: "Ancient Temple",
                description: "An old and beautiful temple located in the hills.",
                shortDescription: "A sacred heritage site.",
                imageURL: "https://example.com/image.jpg",
                arAvailable: true,
                arModelName: "temple_model.usdz",
                location: LocationCoordinate(latitude: 7.8731, longitude: 80.7718),
                category: .heritage
            )
        ]

        mockViewModel.wildlifeItems = [
            WildlifeItem(
                id: "2",
                name: "Sri Lankan Leopard",
                scientificName: "Panthera pardus kotiya",
                description: "A rare and elusive leopard found in Sri Lanka.",
                shortDescription: "Endemic big cat species.",
                imageURL: "https://example.com/leopard.jpg",
                arAvailable: false,
                arModelName: nil,
                status: .endangered,
                population: "Less than 1000",
                habitat: "Forests",
                commonLocations: ["Yala National Park", "Wilpattu"]
            )
        ]

        return FavoritesView()
            .environmentObject(mockViewModel)
    }
}



//
//  FavoritesView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//
import SwiftUI

/// Model representing a saved favorite item (heritage site or wildlife)
struct FavoriteItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageURL: String
    let category: FavoriteCategory
    let dateAdded: Date
    var isFeatured: Bool
    
    enum FavoriteCategory: String, CaseIterable {
        case heritageSite = "Heritage Site"
        case wildlife = "Wildlife"
    }
}

/// ViewModel for managing favorite items
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteItem] = []
    @Published var selectedCategory: FavoriteItem.FavoriteCategory?
    
    init() {
        // Sample data for preview/testing
        loadSampleData()
    }
    
    /// Load sample data for preview/testing purposes
    private func loadSampleData() {
        favorites = [
            FavoriteItem(name: "Sigiriya", description: "Ancient rock fortress", imageURL: "sigiriya", category: .heritageSite, dateAdded: Date().addingTimeInterval(-86400), isFeatured: true),
            FavoriteItem(name: "Polonnaruwa", description: "Medieval capital", imageURL: "polonnaruwa", category: .heritageSite, dateAdded: Date().addingTimeInterval(-172800), isFeatured: false),
            FavoriteItem(name: "Asian Elephant", description: "Native to Sri Lanka", imageURL: "elephant", category: .wildlife, dateAdded: Date().addingTimeInterval(-259200), isFeatured: true),
            FavoriteItem(name: "Sri Lankan Leopard", description: "Endangered species", imageURL: "leopard", category: .wildlife, dateAdded: Date().addingTimeInterval(-345600), isFeatured: false)
        ]
    }
    
    /// Filter favorites based on selected category
    var filteredFavorites: [FavoriteItem] {
        if let category = selectedCategory {
            return favorites.filter { $0.category == category }
        } else {
            return favorites
        }
    }
    
    /// Remove a favorite item
    func removeFavorite(at indexSet: IndexSet) {
        // Find the actual index in the original array based on the filtered array
        let itemsToRemove = indexSet.map { filteredFavorites[$0] }
        for item in itemsToRemove {
            if let index = favorites.firstIndex(where: { $0.id == item.id }) {
                favorites.remove(at: index)
            }
        }
    }
    
    /// Toggle featured status for an item
    func toggleFeatured(_ item: FavoriteItem) {
        if let index = favorites.firstIndex(where: { $0.id == item.id }) {
            favorites[index].isFeatured.toggle()
        }
    }
}

/// Custom card view for displaying favorite items
struct FavoriteItemCard: View {
    let item: FavoriteItem
    var onToggleFeatured: (FavoriteItem) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            Image(item.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Category badge
                    Text(item.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            item.category == .heritageSite ?
                            Color.blue.opacity(0.2) :
                            Color.green.opacity(0.2)
                        )
                        .foregroundColor(
                            item.category == .heritageSite ?
                            Color.blue :
                            Color.green
                        )
                        .cornerRadius(8)
                }
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    // Date added
                    Text("Added \(item.dateAdded, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Star button for featuring
                    Button(action: {
                        onToggleFeatured(item)
                    }) {
                        Image(systemName: item.isFeatured ? "star.fill" : "star")
                            .foregroundColor(item.isFeatured ? .yellow : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

/// Main view for displaying favorites list
struct FavoritesListScreen: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar1(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: viewModel.selectedCategory == nil,
                            action: { viewModel.selectedCategory = nil }
                        )
                        
                        ForEach(FavoriteItem.FavoriteCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                title: category.rawValue,
                                isSelected: viewModel.selectedCategory == category,
                                action: { viewModel.selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                if viewModel.filteredFavorites.isEmpty {
                    // Empty state view
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No favorites yet")
                            .font(.headline)
                        
                        Text("Start exploring and add your favorite heritage sites and wildlife to this list.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Favorites list
                    List {
                        ForEach(viewModel.filteredFavorites.filter {
                            searchText.isEmpty ||
                            $0.name.localizedCaseInsensitiveContains(searchText) ||
                            $0.description.localizedCaseInsensitiveContains(searchText)
                        }) { item in
                            NavigationLink(destination: DetailPlaceholder(item: item)) {
                                FavoriteItemCard(item: item) { favoriteItem in
                                    viewModel.toggleFeatured(favoriteItem)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .onDelete(perform: viewModel.removeFavorite)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

/// Search bar component
struct SearchBar1: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search favorites", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

/// Category filter button component
struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

/// Placeholder for detail screen
struct DetailPlaceholder: View {
    let item: FavoriteItem
    
    var body: some View {
        VStack {
            Text("Detail view for \(item.name)")
                .font(.headline)
            Text("This would connect to the appropriate detail screen")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct FavoritesListScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesListScreen()
    }
}

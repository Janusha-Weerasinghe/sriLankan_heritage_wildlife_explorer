//
//  SearchResultsScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI

// MARK: - SearchResultsScreen
struct SearchResultsScreen: View {
    @ObservedObject var viewModel: SearchResultsViewModel
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()

            List(viewModel.searchResults) { heritageSite in
                NavigationLink(destination: WildlifeDetailView(heritageSite: heritageSite)) {
                    HeritageSiteRow(heritageSite: heritageSite)
                }
            }
            .onAppear {
                viewModel.fetchHeritageSites() // Ensure data is loaded when the screen appears
            }
        }
        .searchable(text: $searchText) // This is the fixed method with proper binding
        .navigationTitle("Search Results")
    }
}

// MARK: - SearchResultsViewModel
class SearchResultsViewModel: ObservableObject {
    @Published var searchResults: [HeritageSite] = []

    func fetchHeritageSites() {
        // Your fetching logic here
        // Example of static data
        searchResults = [
            HeritageSite(id: UUID(), name: "Sigiriya", shortDescription: "A historical rock fortress", fullDescription: "Sigiriya, an ancient rock fortress and palace complex...", imageName: "sigiriya", thumbnailImage: "sigiriya_thumb", images: ["sigiriya_img1", "sigiriya_img2"], location: "Matale, Sri Lanka", coordinates: (latitude: 7.9576, longitude: 80.7608), distance: 15.0, historicalPeriod: "Ancient", yearBuilt: "5th Century", culturalSignificance: "UNESCO World Heritage", hasARExperience: true, isFavorite: true),
            // Add other HeritageSite instances here
        ]
    }
}

// MARK: - HeritageSiteRow
struct HeritageSiteRow: View {
    let heritageSite: HeritageSite

    var body: some View {
        HStack {
            Image(heritageSite.thumbnailImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(heritageSite.name)
                    .font(.headline)
                Text(heritageSite.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - WildlifeDetailView
struct WildlifeDetailView: View {
    let heritageSite: HeritageSite

    var body: some View {
        ScrollView {
            VStack {
                Image(heritageSite.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Text(heritageSite.fullDescription)
                    .padding()
                Text("Location: \(heritageSite.location)")
                    .padding()
                Text("Distance: \(heritageSite.formattedDistance)")
                    .padding()
                // Additional content can go here (e.g., AR experience, historical details)
            }
        }
        .navigationTitle(heritageSite.name)
    }
}

// MARK: - Namespace for miscellaneous components
enum MiscComponents {
    struct SearchBar: View {
        @Binding var text: String

        var body: some View {
            HStack {
                TextField("Search...", text: $text)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Preview
struct SearchResultsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsScreen(viewModel: SearchResultsViewModel())
    }
}

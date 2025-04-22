//
//  SearchResultsScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI
import Combine

// MARK: - Search Results View
/**
 SearchResultsView displays filtered heritage sites and wildlife based on user search terms.
 This view presents search results in a categorized list with section headers.
 */
struct SearchResultsView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: SearchResultsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar at the top
                SearchBar(searchText: $viewModel.searchText, isSearching: $viewModel.isSearching)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Segmented control for filtering
                Picker("Result Type", selection: $selectedTab) {
                    Text("All").tag(0)
                    Text("Heritage").tag(1)
                    Text("Wildlife").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Results count
                HStack {
                    Text("\(viewModel.filteredResults.count) results found")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Results list
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .padding()
                } else if viewModel.filteredResults.isEmpty {
                    emptyResultsView
                } else {
                    resultsList
                }
            }
            .navigationBarTitle("Search Results", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
            )
        }
        .onAppear {
            viewModel.performSearch()
        }
        .onChange(of: selectedTab) { _ in
            viewModel.filterByCategory(selectedTab)
        }
    }
    
    // MARK: - Results List View
    private var resultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                // Heritage Sites Section (if applicable)
                if !viewModel.filteredHeritageResults.isEmpty && (selectedTab == 0 || selectedTab == 1) {
                    resultsSectionHeader(title: "Heritage Sites", count: viewModel.filteredHeritageResults.count)
                    
                    ForEach(viewModel.filteredHeritageResults) { site in
                        NavigationLink(destination: SiteDetailView(site: site)) {
                            SearchResultRow(item: site, itemType: .heritage)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Wildlife Section (if applicable)
                if !viewModel.filteredWildlifeResults.isEmpty && (selectedTab == 0 || selectedTab == 2) {
                    resultsSectionHeader(title: "Wildlife", count: viewModel.filteredWildlifeResults.count)
                    
                    ForEach(viewModel.filteredWildlifeResults) { animal in
                        NavigationLink(destination: WildlifeDetailView(wildlife: animal)) {
                            SearchResultRow(item: animal, itemType: .wildlife)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Empty Results View
    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            Text("No results found")
                .font(.headline)
            Text("Try a different search term or browse our featured content")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Section Header
    private func resultsSectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("(\(count))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Search Result Row View
/**
 SearchResultRow displays individual search result items with appropriate styling
 based on whether they are heritage sites or wildlife.
 */
struct SearchResultRow: View {
    // Item can be either heritage site or wildlife
    let item: Searchable
    let itemType: SearchResultType
    
    var body: some View {
        HStack(spacing: 16) {
            // Item image
            Image(item.thumbnailImage)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // Item info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(item.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Tag showing type of item
                HStack {
                    Text(itemType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(itemType == .heritage ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                        .foregroundColor(itemType == .heritage ? .blue : .green)
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    // Distance info if available
                    if let distance = item.distance {
                        Text("\(String(format: "%.1f", distance)) km")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Search Bar Component
/**
 Reusable search bar component with search functionality
 */
struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search heritage sites, wildlife...", text: $searchText)
                    .foregroundColor(.primary)
                    .focused($isFocused)
                    .onSubmit {
                        isSearching = true
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .onTapGesture {
                isFocused = true
            }
            
            if isFocused {
                Button("Cancel") {
                    isFocused = false
                    searchText = ""
                    isSearching = false
                }
                .transition(.move(edge: .trailing))
                .animation(.default, value: isFocused)
            }
        }
    }
}

// MARK: - Models & Protocols
/**
 Protocol defining requirements for searchable items
 */
protocol Searchable: Identifiable {
    var id: UUID { get }
    var name: String { get }
    var shortDescription: String { get }
    var thumbnailImage: String { get }
    var distance: Double? { get }
}

/**
 Enum defining types of search results
 */
enum SearchResultType: String {
    case heritage = "Heritage Site"
    case wildlife = "Wildlife"
}

// MARK: - Models for Heritage and Wildlife
/**
 Model representing heritage sites
 */
struct HeritageSite: Searchable, Identifiable {
    var id = UUID()
    var name: String
    var shortDescription: String
    var fullDescription: String
    var thumbnailImage: String
    var images: [String]
    var location: (latitude: Double, longitude: Double)
    var distance: Double?
    var historicalPeriod: String
    var hasARExperience: Bool
    
    // Additional heritage-specific properties
    var yearBuilt: String
    var culturalSignificance: String
}

/**
 Model representing wildlife
 */
struct Wildlife: Searchable, Identifiable {
    var id = UUID()
    var name: String
    var scientificName: String
    var shortDescription: String
    var fullDescription: String
    var thumbnailImage: String
    var images: [String]
    var conservationStatus: String
    var habitat: String
    var distance: Double?
    var hasARExperience: Bool
    
    // Additional wildlife-specific properties
    var diet: String
    var lifespan: String
}

// MARK: - View Model
/**
 ViewModel to handle the search functionality and data management
 */
class SearchResultsViewModel: ObservableObject {
    // Published properties for UI updates
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    @Published var filteredResults: [Searchable] = []
    @Published var filteredHeritageResults: [HeritageSite] = []
    @Published var filteredWildlifeResults: [Wildlife] = []
    
    // Data source properties
    private var allHeritageSites: [HeritageSite] = []
    private var allWildlife: [Wildlife] = []
    private var currentTab: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(initialSearchText: String = "") {
        self.searchText = initialSearchText
        
        // Load data
        loadData()
        
        // Set up search text publisher
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty && text.count >= 2 {
                    self?.performSearch()
                } else if text.isEmpty {
                    self?.clearResults()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Methods
    /**
     Loads initial data for heritage sites and wildlife
     In a real app, this would fetch from a database or API
     */
    private func loadData() {
        // Sample data for heritage sites
        allHeritageSites = [
            HeritageSite(
                name: "Sigiriya",
                shortDescription: "Ancient rock fortress with frescoes",
                fullDescription: "Sigiriya is an ancient rock fortress located in the northern Matale District. The site contains the ruins of an ancient palace complex, built during the reign of King Kashyapa.",
                thumbnailImage: "sigiriya_thumb",
                images: ["sigiriya_1", "sigiriya_2", "sigiriya_3"],
                location: (latitude: 7.9572, longitude: 80.7603),
                distance: 120.5,
                historicalPeriod: "5th Century CE",
                hasARExperience: true,
                yearBuilt: "477-495 CE",
                culturalSignificance: "UNESCO World Heritage Site"
            ),
            HeritageSite(
                name: "Polonnaruwa",
                shortDescription: "Medieval capital with monuments",
                fullDescription: "Polonnaruwa is the second most ancient of Sri Lanka's kingdoms. It contains splendid and spectacular statues and is a UNESCO World Heritage Site.",
                thumbnailImage: "polonnaruwa_thumb",
                images: ["polonnaruwa_1", "polonnaruwa_2"],
                location: (latitude: 7.9403, longitude: 81.0188),
                distance: 135.2,
                historicalPeriod: "12th Century CE",
                hasARExperience: true,
                yearBuilt: "1070-1200 CE",
                culturalSignificance: "UNESCO World Heritage Site"
            ),
            HeritageSite(
                name: "Anuradhapura",
                shortDescription: "Ancient sacred city with dagobas",
                fullDescription: "Anuradhapura is one of the ancient capitals of Sri Lanka, famous for its well-preserved ruins of an ancient civilization.",
                thumbnailImage: "anuradhapura_thumb",
                images: ["anuradhapura_1", "anuradhapura_2"],
                location: (latitude: 8.3114, longitude: 80.4037),
                distance: 205.8,
                historicalPeriod: "4th Century BCE",
                hasARExperience: true,
                yearBuilt: "377 BCE",
                culturalSignificance: "UNESCO World Heritage Site"
            )
        ]
        
        // Sample data for wildlife
        allWildlife = [
            Wildlife(
                name: "Sri Lankan Elephant",
                scientificName: "Elephas maximus maximus",
                shortDescription: "Largest subspecies of Asian elephant",
                fullDescription: "The Sri Lankan elephant is native to Sri Lanka and one of three recognized subspecies of the Asian elephant. It is the largest of all Asian elephant subspecies.",
                thumbnailImage: "elephant_thumb",
                images: ["elephant_1", "elephant_2"],
                conservationStatus: "Endangered",
                habitat: "Dry zone forests",
                distance: 85.3,
                hasARExperience: true,
                diet: "Herbivore",
                lifespan: "60-70 years"
            ),
            Wildlife(
                name: "Sri Lankan Leopard",
                scientificName: "Panthera pardus kotiya",
                shortDescription: "Top predator and unique subspecies",
                fullDescription: "The Sri Lankan leopard is a leopard subspecies native to Sri Lanka. It is listed as Endangered on the IUCN Red List.",
                thumbnailImage: "leopard_thumb",
                images: ["leopard_1", "leopard_2"],
                conservationStatus: "Endangered",
                habitat: "Rainforests and arid scrublands",
                distance: 92.7,
                hasARExperience: true,
                diet: "Carnivore",
                lifespan: "12-17 years"
            ),
            Wildlife(
                name: "Ceylon Junglefowl",
                scientificName: "Gallus lafayettii",
                shortDescription: "National bird of Sri Lanka",
                fullDescription: "The Ceylon junglefowl is endemic to Sri Lanka, where it is the national bird. It's closely related to the domestic chicken.",
                thumbnailImage: "junglefowl_thumb",
                images: ["junglefowl_1", "junglefowl_2"],
                conservationStatus: "Least Concern",
                habitat: "Dense forests",
                distance: 45.1,
                hasARExperience: false,
                diet: "Omnivore",
                lifespan: "5-8 years"
            )
        ]
    }
    
    // MARK: - Search Methods
    /**
     Performs the search based on the current search text
     */
    func performSearch() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Filter heritage sites
            self.filteredHeritageResults = self.allHeritageSites.filter { site in
                return site.name.lowercased().contains(self.searchText.lowercased()) ||
                       site.shortDescription.lowercased().contains(self.searchText.lowercased()) ||
                       site.historicalPeriod.lowercased().contains(self.searchText.lowercased())
            }
            
            // Filter wildlife
            self.filteredWildlifeResults = self.allWildlife.filter { animal in
                return animal.name.lowercased().contains(self.searchText.lowercased()) ||
                       animal.scientificName.lowercased().contains(self.searchText.lowercased()) ||
                       animal.shortDescription.lowercased().contains(self.searchText.lowercased()) ||
                       animal.conservationStatus.lowercased().contains(self.searchText.lowercased())
            }
            
            // Apply category filter based on currently selected tab
            self.filterByCategory(self.currentTab)
            
            self.isLoading = false
        }
    }
    
    /**
     Filters results by category
     - Parameter tabIndex: The index of the selected tab (0 = All, 1 = Heritage, 2 = Wildlife)
     */
    func filterByCategory(_ tabIndex: Int) {
        currentTab = tabIndex
        
        switch tabIndex {
        case 0: // All
            filteredResults = (filteredHeritageResults as [Searchable]) + (filteredWildlifeResults as [Searchable])
        case 1: // Heritage
            filteredResults = filteredHeritageResults as [Searchable]
        case 2: // Wildlife
            filteredResults = filteredWildlifeResults as [Searchable]
        default:
            filteredResults = []
        }
    }
    
    /**
     Clears search results
     */
    private func clearResults() {
        filteredHeritageResults = []
        filteredWildlifeResults = []
        filteredResults = []
    }
}

// MARK: - Site Detail View (Placeholder)
/**
 View for displaying heritage site details
 In a real app, this would be a full detail view
 */
struct SiteDetailView: View {
    let site: HeritageSite
    
    var body: some View {
        Text("Detail view for \(site.name)")
            .padding()
            .navigationTitle(site.name)
    }
}

// MARK: - Wildlife Detail View (Placeholder)
/**
 View for displaying wildlife details
 In a real app, this would be a full detail view
 */
struct WildlifeDetailView: View {
    let wildlife: Wildlife
    
    var body: some View {
        Text("Detail view for \(wildlife.name)")
            .padding()
            .navigationTitle(wildlife.name)
    }
}

// MARK: - Preview Provider
struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchResultsViewModel(initialSearchText: "elephant")
        return SearchResultsView(viewModel: viewModel)
    }
}

////
////  WildlifeExplorerScreen.swift
////  srilankan_heritage_wildlife_explorer
////
////  Created by Janusha 023 on 2025-04-22.
////
//import SwiftUI
//import MapKit
//
//// MARK: - Models
///// Model representing wildlife species
//struct WildlifeSpecies: Identifiable {
//    let id = UUID()
//    let name: String
//    let scientificName: String
//    let category: String
//    let conservationStatus: String
//    let shortDescription: String
//    let imageName: String
//    let isFavorite: Bool
//}
//
//// MARK: - Wildlife Explorer View
///// Main view for the Wildlife Explorer screen
//struct WildlifeExplorerView: View {
//    // MARK: - Properties
//    @State private var searchText = ""
//    @State private var isSearching = false
//    @State private var selectedCategory = "All"
//    @State private var showARView = false
//    @State private var selectedSpecies: WildlifeSpecies?
//    
//    // Category options for wildlife
//    private let categoryOptions = ["All", "Mammals", "Birds", "Reptiles", "Endangered"]
//    
//    // Sample data for wildlife species
//    private let wildlifeSpecies = [
//        WildlifeSpecies(
//            name: "Sri Lankan Elephant",
//            scientificName: "Elephas maximus maximus",
//            category: "Mammals",
//            conservationStatus: "Endangered",
//            shortDescription: "The largest subspecies of Asian elephant native to Sri Lanka",
//            imageName: "elephant",
//            isFavorite: true
//        ),
//        WildlifeSpecies(
//            name: "Sri Lankan Leopard",
//            scientificName: "Panthera pardus kotiya",
//            category: "Mammals",
//            conservationStatus: "Endangered",
//            shortDescription: "Endemic subspecies of leopard found only in Sri Lanka",
//            imageName: "leopard",
//            isFavorite: false
//        ),
//        WildlifeSpecies(
//            name: "Purple-faced Langur",
//            scientificName: "Semnopithecus vetulus",
//            category: "Mammals",
//            conservationStatus: "Endangered",
//            shortDescription: "Endemic old world monkey with distinctive facial features",
//            imageName: "langur",
//            isFavorite: true
//        ),
//        WildlifeSpecies(
//            name: "Sri Lankan Junglefowl",
//            scientificName: "Gallus lafayettii",
//            category: "Birds",
//            conservationStatus: "Least Concern",
//            shortDescription: "National bird of Sri Lanka related to domestic chickens",
//            imageName: "junglefowl",
//            isFavorite: false
//        ),
//        WildlifeSpecies(
//            name: "Saltwater Crocodile",
//            scientificName: "Crocodylus porosus",
//            category: "Reptiles",
//            conservationStatus: "Least Concern",
//            shortDescription: "Largest living reptile found in Sri Lankan waterways",
//            imageName: "crocodile",
//            isFavorite: true
//        )
//    ]
//    
//    // MARK: - Body
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // Custom header
//                headerView
//                
//                // Search bar
//                searchBarView
//                
//                // Category filter chips
//                categoryFilterView
//                
//                // Main content
//                ScrollView {
//                    VStack(spacing: 16) {
//                        featuredSpeciesView
//                        endangeredSpeciesView
//                        wildlifeMapView
//                    }
//                    .padding(.bottom, 16)
//                }
//            }
//            .navigationBarHidden(true)
//            .background(Color(UIColor.systemBackground))
//            .sheet(isPresented: $showARView) {
//                // This would be implemented separately as AR requires ARKit
//                Text("AR View for \(selectedSpecies?.name ?? "Wildlife")")
//                    .font(.title)
//                    .padding()
//            }
//            .sheet(item: $selectedSpecies) { species in
//                // This would navigate to detailed view in actual implementation
//                WildlifeDetailView(heritageSite: species)
//            }
//        }
//    }
//    
//    // MARK: - UI Components
//    
//    /// Custom header for the Wildlife Explorer screen
//    private var headerView: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Wildlife Explorer")
//                    .font(.title)
//                    .fontWeight(.bold)
//                Text("Discover Sri Lanka's amazing biodiversity")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                // Implementation for filters
//            }) {
//                Image(systemName: "slider.horizontal.3")
//                    .font(.title2)
//                    .foregroundColor(.primary)
//            }
//        }
//        .padding()
//        .background(Color(UIColor.systemBackground))
//    }
//    
//    /// Search bar for finding wildlife species
//    private var searchBarView: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//            
//            TextField("Search wildlife species", text: $searchText, onEditingChanged: { editing in
//                withAnimation {
//                    isSearching = editing
//                }
//            })
//            .font(.body)
//            
//            if !searchText.isEmpty {
//                Button(action: {
//                    searchText = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .padding(10)
//        .background(Color(UIColor.secondarySystemBackground))
//        .cornerRadius(10)
//        .padding(.horizontal)
//    }
//    
//    /// Horizontal scrollable category filters
//    private var categoryFilterView: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 12) {
//                ForEach(categoryOptions, id: \.self) { category in
//                    Button(action: {
//                        withAnimation {
//                            selectedCategory = category
//                        }
//                    }) {
//                        Text(category)
//                            .font(.subheadline)
//                            .fontWeight(selectedCategory == category ? .semibold : .regular)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .background(
//                                selectedCategory == category
//                                ? Color.green.opacity(0.2)
//                                : Color(UIColor.tertiarySystemBackground)
//                            )
//                            .foregroundColor(selectedCategory == category ? .green : .primary)
//                            .cornerRadius(20)
//                    }
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 10)
//        }
//    }
//    
//    /// Featured wildlife species with AR experience button
//    private var featuredSpeciesView: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Featured Species")
//                .font(.headline)
//                .fontWeight(.bold)
//                .padding(.horizontal)
//            
//            ZStack(alignment: .bottomLeading) {
//                // Featured image
//                Image("elephant")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 200)
//                    .clipped()
//                    .cornerRadius(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                
//                // AR Experience button
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Sri Lankan Elephant")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                            
//                            Text("Elephas maximus maximus")
//                                .font(.subheadline)
//                                .fontStyle(.italic)
//                                .foregroundColor(.white.opacity(0.9))
//                        }
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            selectedSpecies = wildlifeSpecies[0]
//                            showARView = true
//                        }) {
//                            Label("AR", systemImage: "arkit")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 6)
//                                .background(Color.green)
//                                .cornerRadius(20)
//                        }
//                    }
//                    
//                    HStack {
//                        Text("Conservation Status:")
//                            .font(.caption)
//                            .foregroundColor(.white.opacity(0.9))
//                        
//                        Text("Endangered")
//                            .font(.caption)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 2)
//                            .background(Color.red.opacity(0.7))
//                            .cornerRadius(10)
//                    }
//                    
//                    Text("Experience the majestic Sri Lankan elephant in augmented reality")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                }
//                .padding()
//                .background(
//                    LinearGradient(
//                        gradient: Gradient(
//                            colors: [.black.opacity(0.7), .black.opacity(0.2), .clear]
//                        ),
//                        startPoint: .bottom,
//                        endPoint: .top
//                    )
//                )
//                .cornerRadius(12)
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//    /// Horizontal scrollable endangered species
//    private var endangeredSpeciesView: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Endangered Species")
//                .font(.headline)
//                .fontWeight(.bold)
//                .padding(.horizontal)
//                .padding(.top, 8)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 16) {
//                    ForEach(wildlifeSpecies.filter { $0.conservationStatus == "Endangered" }) { species in
//                        WildlifeCard(species: species) {
//                            selectedSpecies = species
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 8)
//            }
//        }
//    }
//    
//    /// Wildlife locations map view
//    private var wildlifeMapView: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Wildlife Hotspots")
//                .font(.headline)
//                .fontWeight(.bold)
//                .padding(.horizontal)
//                .padding(.top, 8)
//            
//            ZStack(alignment: .bottomTrailing) {
//                // Map placeholder
//                Rectangle()
//                    .fill(Color(UIColor.tertiarySystemBackground))
//                    .frame(height: 180)
//                    .cornerRadius(12)
//                    .overlay(
//                        Text("Wildlife Locations Map")
//                            .font(.title3)
//                            .foregroundColor(.secondary)
//                    )
//                    .padding(.horizontal)
//                
//                // Explore button
//                Button(action: {
//                    // Action to navigate to full map view
//                }) {
//                    Text("Explore Habitats")
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(Color.green)
//                        .cornerRadius(20)
//                }
//                .padding()
//            }
//        }
//    }
//}
//
//// MARK: - Wildlife Card Component
///// Reusable card component for displaying wildlife species
//struct WildlifeCard: View {
//    // MARK: - Properties
//    let species: WildlifeSpecies
//    let onTap: () -> Void
//    @State private var isFavorite: Bool
//    
//    // MARK: - Initialization
//    init(species: WildlifeSpecies, onTap: @escaping () -> Void) {
//        self.species = species
//        self.onTap = onTap
//        _isFavorite = State(initialValue: species.isFavorite)
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        Button(action: onTap) {
//            VStack(alignment: .leading, spacing: 8) {
//                // Image
//                ZStack(alignment: .topTrailing) {
//                    Image(species.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 160, height: 120)
//                        .clipped()
//                        .cornerRadius(12)
//                    
//                    // Favorite button
//                    Button(action: {
//                        isFavorite.toggle()
//                    }) {
//                        Image(systemName: isFavorite ? "heart.fill" : "heart")
//                            .foregroundColor(isFavorite ? .red : .white)
//                            .font(.system(size: 18))
//                            .padding(8)
//                            .background(Color.black.opacity(0.3))
//                            .clipShape(Circle())
//                    }
//                    .padding(8)
//                }
//                
//                // Species name
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(species.name)
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//                        .lineLimit(1)
//                    
//                    Text(species.scientificName)
//                        .font(.caption)
//                        .fontStyle(.italic)
//                        .foregroundColor(.secondary)
//                        .lineLimit(1)
//                }
//                
//                // Conservation status
//                HStack {
//                    Text(species.conservationStatus)
//                        .font(.caption)
//                        .fontWeight(.medium)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 2)
//                        .background(species.conservationStatus == "Endangered" ? Color.red : Color.green)
//                        .cornerRadius(10)
//                    
//                    Spacer()
//                    
//                    Text(species.category)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                // Short description
//                Text(species.shortDescription)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .lineLimit(2)
//                    .frame(width: 160)
//            }
//            .frame(width: 160)
//            .padding(.bottom, 8)
//            .background(Color(UIColor.systemBackground))
//            .cornerRadius(12)
//            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// MARK: - Wildlife Detail View
///// Detailed view for a wildlife species
//struct WildlifeDetailView: View {
//    // MARK: - Properties
//    let species: WildlifeSpecies
//    @Environment(\.presentationMode) var presentationMode
//    @State private var showARExperience = false
//    @State private var selectedTab = 0
//    
//    // MARK: - Body
//    var body: some View {
//        // This is a placeholder for the detailed view
//        // In a real implementation, this would include comprehensive information,
//        // tabs for biology, habitat, conservation, etc.
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // Header image with back button
//                ZStack(alignment: .top) {
//                    Image(species.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 250)
//                        .clipped()
//                    
//                    VStack {
//                        HStack {
//                            Button(action: {
//                                presentationMode.wrappedValue.dismiss()
//                            }) {
//                                Image(systemName: "chevron.left")
//                                    .font(.title2)
//                                    .foregroundColor(.white)
//                                    .padding(12)
//                                    .background(Color.black.opacity(0.5))
//                                    .clipShape(Circle())
//                            }
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                // Action for sharing
//                            }) {
//                                Image(systemName: "square.and.arrow.up")
//                                    .font(.title2)
//                                    .foregroundColor(.white)
//                                    .padding(12)
//                                    .background(Color.black.opacity(0.5))
//                                    .clipShape(Circle())
//                            }
//                        }
//                        .padding()
//                        
//                        Spacer()
//                    }
//                }
//                
//                VStack(alignment: .leading, spacing: 20) {
//                    // Title and scientific name
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(species.name)
//                            .font(.title)
//                            .fontWeight(.bold)
//                        
//                        Text(species.scientificName)
//                            .font(.headline)
//                            .fontStyle(.italic)
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    // Conservation status
//                    HStack {
//                        Text("Conservation Status:")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                        
//                        Text(species.conservationStatus)
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 4)
//                            .background(species.conservationStatus == "Endangered" ? Color.red : Color.green)
//                            .cornerRadius(10)
//                    }
//                    
//                    // Action buttons
//                    HStack(spacing: 16) {
//                        Button(action: {
//                            // Navigate to habitat action
//                        }) {
//                            Label("Find in Wild", systemImage: "map.fill")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color.green)
//                                .cornerRadius(10)
//                        }
//                        
//                        Button(action: {
//                            showARExperience = true
//                        }) {
//                            Label("AR Experience", systemImage: "arkit")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color.purple)
//                                .cornerRadius(10)
//                        }
//                    }
//                    
//                    // Tab selector
//                    VStack(spacing: 16) {
//                        // Tab buttons
//                        HStack {
//                            TabButton(title: "About", isSelected: selectedTab == 0) {
//                                selectedTab = 0
//                            }
//                            
//                            TabButton(title: "Habitat", isSelected: selectedTab == 1) {
//                                selectedTab = 1
//                            }
//                            
//                            TabButton(title: "Conservation", isSelected: selectedTab == 2) {
//                                selectedTab = 2
//                            }
//                            
//                            TabButton(title: "Gallery", isSelected: selectedTab == 3) {
//                                selectedTab = 3
//                            }
//                        }
//                        
//                        // Tab content
//                        VStack(alignment: .leading, spacing: 12) {
//                            switch selectedTab {
//                            case 0:
//                                // About tab
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Text("About")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                    
//                                    Text("This is a detailed description of the \(species.name). In the actual implementation, this would include comprehensive information about the species, including its physical characteristics, behavior, diet, and lifecycle.")
//                                        .font(.body)
//                                        .foregroundColor(.secondary)
//                                        .lineSpacing(4)
//                                }
//                                
//                            case 1:
//                                // Habitat tab
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Text("Habitat")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                    
//                                    Text("Information about the natural habitat of the \(species.name) would be displayed here, including distribution maps, preferred environments, and key locations where this species can be found in Sri Lanka.")
//                                        .font(.body)
//                                        .foregroundColor(.secondary)
//                                        .lineSpacing(4)
//                                }
//                                
//                            case 2:
//                                // Conservation tab
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Text("Conservation")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                    
//                                    Text("Details about the conservation status, threats, and protection measures for the \(species.name) would be provided here, along with information about ongoing conservation programs in Sri Lanka.")
//                                        .font(.body)
//                                        .foregroundColor(.secondary)
//                                        .lineSpacing(4)
//                                }
//                                
//                            case 3:
//                                // Gallery tab
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Text("Gallery")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                    
//                                    Text("A collection of high-quality images and videos of the \(species.name) would be displayed here, showcasing the species in its natural habitat and highlighting key characteristics.")
//                                        .font(.body)
//                                        .foregroundColor(.secondary)
//                                        .lineSpacing(4)
//                                }
//                                
//                            default:
//                                Text("Content not available")
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .edgesIgnoringSafeArea(.top)
//        .sheet(isPresented: $showARExperience) {
//            // AR Experience would be implemented using ARKit
//            Text("AR Experience for \(species.name)")
//                .font(.title)
//                .padding()
//        }
//    }
//}
//
//// MARK: - Tab Button Component
///// Reusable button for tab selection
//struct TabButton: View {
//    // MARK: - Properties
//    let title: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    // MARK: - Body
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 8) {
//                Text(title)
//                    .font(.subheadline)
//                    .fontWeight(isSelected ? .semibold : .regular)
//                    .foregroundColor(isSelected ? .primary : .secondary)
//                
//                // Indicator line
//                Rectangle()
//                    .fill(isSelected ? Color.green : Color.clear)
//                    .frame(height: 3)
//                    .cornerRadius(1.5)
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// MARK: - Preview Provider
//struct WildlifeExplorerView_Previews: PreviewProvider {
//    static var previews: some View {
//        WildlifeExplorerView()
//    }
//}

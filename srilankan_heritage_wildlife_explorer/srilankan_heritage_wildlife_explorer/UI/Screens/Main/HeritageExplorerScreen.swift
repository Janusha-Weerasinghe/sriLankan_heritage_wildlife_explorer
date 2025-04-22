//
//  WildlifeRepository.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI
import MapKit

// MARK: - Models
/// Model representing a heritage site
struct HeritageSite: Identifiable {
    let id = UUID()
    let name: String
    let shortDescription: String
    let imageName: String
    let location: String
    let distance: String
    let isFavorite: Bool
}

// MARK: - Heritage Exploration View
/// Main view for the Heritage Exploration screen
struct HeritageExplorationView: View {
    // MARK: - Properties
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedFilter = "All"
    @State private var showARView = false
    @State private var selectedSite: HeritageSite?
    
    // Filter options for heritage sites
    private let filterOptions = ["All", "Popular", "Nearby", "Historical", "UNESCO"]
    
    // Sample data for heritage sites
    private let heritageSites = [
        HeritageSite(name: "Sigiriya", shortDescription: "Ancient rock fortress with frescoes", imageName: "sigiriya", location: "Central Province", distance: "120 km", isFavorite: true),
        HeritageSite(name: "Polonnaruwa", shortDescription: "Medieval capital & UNESCO site", imageName: "polonnaruwa", location: "North Central", distance: "215 km", isFavorite: false),
        HeritageSite(name: "Anuradhapura", shortDescription: "Sacred ancient city", imageName: "anuradhapura", location: "North Central", distance: "240 km", isFavorite: true),
        HeritageSite(name: "Temple of the Tooth", shortDescription: "Sacred Buddhist temple", imageName: "temple_tooth", location: "Kandy", distance: "85 km", isFavorite: false),
        HeritageSite(name: "Galle Fort", shortDescription: "Dutch colonial fortification", imageName: "galle_fort", location: "Southern Province", distance: "175 km", isFavorite: true)
    ]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom header
                headerView
                
                // Search bar
                searchBarView
                
                // Filter chips
                filterChipsView
                
                // Main content
                ScrollView {
                    VStack(spacing: 16) {
                        featuredSiteView
                        popularSitesView
                        mapExplorerView
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
            .background(Color(UIColor.systemBackground))
            .sheet(isPresented: $showARView) {
                // This would be implemented separately as AR requires ARKit
                Text("AR View for \(selectedSite?.name ?? "Heritage Site")")
                    .font(.title)
                    .padding()
            }
            .sheet(item: $selectedSite) { site in
                // This would navigate to detailed view in actual implementation
                HeritageSiteDetailView(site: site)
            }
        }
    }
    
    // MARK: - UI Components
    
    /// Custom header for the Heritage Exploration screen
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Heritage Explorer")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Discover Sri Lanka's rich cultural heritage")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Implementation for filters
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
    
    /// Search bar for finding heritage sites
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search heritage sites", text: $searchText, onEditingChanged: { editing in
                withAnimation {
                    isSearching = editing
                }
            })
            .font(.body)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    /// Horizontal scrollable filter chips
    private var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filterOptions, id: \.self) { filter in
                    Button(action: {
                        withAnimation {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedFilter == filter
                                ? Color.blue.opacity(0.2)
                                : Color(UIColor.tertiarySystemBackground)
                            )
                            .foregroundColor(selectedFilter == filter ? .blue : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
    
    /// Featured site card with AR button
    private var featuredSiteView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Site")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ZStack(alignment: .bottomLeading) {
                // Featured image
                Image("sigiriya")
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
                        Text("Sigiriya")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedSite = heritageSites[0]
                            showARView = true
                        }) {
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
                    
                    Text("Experience the ancient rock fortress in augmented reality")
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
    
    /// Horizontal scrollable popular sites
    private var popularSitesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular Heritage Sites")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(heritageSites) { site in
                        HeritageSiteCard(site: site) {
                            selectedSite = site
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
    
    /// Map explorer preview
    private var mapExplorerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Map Explorer")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            ZStack(alignment: .bottomTrailing) {
                // Map placeholder
                Rectangle()
                    .fill(Color(UIColor.tertiarySystemBackground))
                    .frame(height: 180)
                    .cornerRadius(12)
                    .overlay(
                        Text("Interactive Map")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    )
                    .padding(.horizontal)
                
                // Navigate button
                Button(action: {
                    // Action to navigate to full map view
                }) {
                    Text("Open Full Map")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding()
            }
        }
    }
}

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
                    
                    Text(site.distance)
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

// MARK: - Heritage Site Detail View
/// Detailed view for a heritage site
struct HeritageSiteDetailView: View {
    // MARK: - Properties
    let site: HeritageSite
    @Environment(\.presentationMode) var presentationMode
    @State private var showARExperience = false
    
    // MARK: - Body
    var body: some View {
        // This is a placeholder for the detailed view
        // In a real implementation, this would include comprehensive information,
        // tabs for history, gallery, reviews, etc.
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
                        }
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
                    
                    // Description placeholder
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("This is a detailed description of \(site.name). In the actual implementation, this would include comprehensive information about the heritage site, its history, cultural significance, and notable features.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                        
                        // Additional content would go here
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

// MARK: - Preview Provider
struct HeritageExplorationView_Previews: PreviewProvider {
    static var previews: some View {
        HeritageExplorationView()
    }
}

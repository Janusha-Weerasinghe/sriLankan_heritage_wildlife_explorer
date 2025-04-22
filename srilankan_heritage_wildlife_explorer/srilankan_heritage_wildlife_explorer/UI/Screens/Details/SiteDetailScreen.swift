//
//  SiteDetailScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI
import MapKit
import CoreData

// MARK: - Models

/// Model representing a detailed heritage site or wildlife entity
struct DetailItem: Identifiable {
    let id = UUID()
    let name: String
    let type: ItemType // Heritage site or wildlife
    let images: [String]
    let description: String
    let location: CLLocationCoordinate2D
    let funFacts: [String]
    let conservationStatus: ConservationStatus?
    let historicalPeriod: String?
    let arModelAvailable: Bool
    
    enum ItemType {
        case heritageSite
        case wildlife
    }
    
    enum ConservationStatus: String {
        case leastConcern = "Least Concern"
        case nearThreatened = "Near Threatened"
        case vulnerable = "Vulnerable"
        case endangered = "Endangered"
        case criticallyEndangered = "Critically Endangered"
        
        var color: Color {
            switch self {
            case .leastConcern: return .green
            case .nearThreatened: return .mint
            case .vulnerable: return .yellow
            case .endangered: return .orange
            case .criticallyEndangered: return .red
            }
        }
    }
}

// MARK: - View Components

/// Reusable components for the detail page
struct DetailComponents {
    /// Header image carousel component
    struct ImageCarousel: View {
        let images: [String]
        @State private var currentIndex = 0
        
        var body: some View {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 250)
            .overlay(
                // Image counter overlay
                HStack {
                    Spacer()
                    Text("\(currentIndex + 1)/\(images.count)")
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding([.bottom, .trailing], 12)
                }
                .alignmentGuide(.bottom) { _ in 0 },
                alignment: .bottom
            )
        }
    }
    
    /// Info card component with consistent styling
    struct InfoCard<Content: View>: View {
        let title: String
        let icon: String
        let content: Content
        
        init(title: String, icon: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.icon = icon
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.accentColor)
                    Text(title)
                        .font(.headline)
                }
                
                content
                    .padding(.leading, 8)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    /// Fun facts component with expandable details
    struct FunFactsSection: View {
        let facts: [String]
        @State private var showAllFacts = false
        
        var body: some View {
            InfoCard(title: "Fun Facts", icon: "lightbulb.fill") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<(showAllFacts ? facts.count : min(2, facts.count)), id: \.self) { index in
                        HStack(alignment: .top) {
                            Text("•")
                            Text(facts[index])
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    if facts.count > 2 {
                        Button(action: {
                            withAnimation {
                                showAllFacts.toggle()
                            }
                        }) {
                            Text(showAllFacts ? "Show Less" : "Show More")
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 8)
                        }
                    }
                }
            }
        }
    }
    
    /// Map preview component
    struct MapPreview: View {
        let coordinate: CLLocationCoordinate2D
        let name: String
        
        @State private var region: MKCoordinateRegion
        
        init(coordinate: CLLocationCoordinate2D, name: String) {
            self.coordinate = coordinate
            self.name = name
            self._region = State(initialValue: MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
        
        var body: some View {
            InfoCard(title: "Location", icon: "map") {
                Map(coordinateRegion: $region, annotationItems: [MapAnnotation(name: name, coordinate: coordinate)]) { item in
                    MapMarker(coordinate: item.coordinate, tint: .accentColor)
                }
                .frame(height: 180)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
        
        struct MapAnnotation: Identifiable {
            let id = UUID()
            let name: String
            let coordinate: CLLocationCoordinate2D
        }
    }
    
    /// Conservation status badge component
    struct ConservationStatusBadge: View {
        let status: DetailItem.ConservationStatus
        
        var body: some View {
            HStack {
                Circle()
                    .fill(status.color)
                    .frame(width: 12, height: 12)
                Text(status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(status.color.opacity(0.15))
            .cornerRadius(20)
        }
    }
    
    /// Action button component
    struct ActionButton: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                    Text(title)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Detail View Controller

/// Main view controller for Site/Wildlife detail page
struct SiteWildlifeDetailView: View {
    // MARK: - Properties
    
    let item: DetailItem
    @State private var isFavorite: Bool = false
    @State private var showARView: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image carousel
                DetailComponents.ImageCarousel(images: item.images)
                    
                // Title and action buttons
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Favorite button
                        Button(action: toggleFavorite) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Type and conservation status
                    HStack {
                        Text(item.type == .heritageSite ? "Heritage Site" : "Wildlife")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(20)
                        
                        if let status = item.conservationStatus {
                            DetailComponents.ConservationStatusBadge(status: status)
                        }
                        
                        if let period = item.historicalPeriod, item.type == .heritageSite {
                            Text(period)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.purple.opacity(0.15))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Description section
                DetailComponents.InfoCard(title: "About", icon: "info.circle") {
                    Text(item.description)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Fun facts section
                DetailComponents.FunFactsSection(facts: item.funFacts)
                
                // Map preview
                DetailComponents.MapPreview(coordinate: item.location, name: item.name)
                
                // Action buttons
                VStack(spacing: 12) {
                    if item.arModelAvailable {
                        DetailComponents.ActionButton(
                            title: "View in AR",
                            icon: "arkit",
                            action: { showARView = true }
                        )
                    }
                    
                    DetailComponents.ActionButton(
                        title: "Get Directions",
                        icon: "map",
                        action: openInMaps
                    )
                    
                    DetailComponents.ActionButton(
                        title: "Share",
                        icon: "square.and.arrow.up",
                        action: shareItem
                    )
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Show additional options menu
                    // Implementation would go here
                }) {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .onAppear {
            checkIfFavorite()
        }
        .sheet(isPresented: $showARView) {
            // AR View placeholder - would be replaced with actual ARKit view
            Text("AR View for \(item.name)")
                .font(.title)
                .padding()
        }
    }
    
    // MARK: - Methods
    
    /// Toggles favorite status and updates Core Data
    private func toggleFavorite() {
        isFavorite.toggle()
        
        // Core Data logic to save favorite status
        if isFavorite {
            saveFavorite()
        } else {
            removeFavorite()
        }
    }
    
    /// Saves item to favorites in Core Data
    private func saveFavorite() {
        // Core Data implementation would go here
        // This is a placeholder for actual Core Data implementation
        print("Saved \(item.name) to favorites")
    }
    
    /// Removes item from favorites in Core Data
    private func removeFavorite() {
        // Core Data implementation would go here
        // This is a placeholder for actual Core Data implementation
        print("Removed \(item.name) from favorites")
    }
    
    /// Checks if item is already favorited
    private func checkIfFavorite() {
        // Core Data fetch request would go here
        // This is a placeholder for actual Core Data implementation
        isFavorite = UserDefaults.standard.bool(forKey: "favorite_\(item.id)")
    }
    
    /// Opens the location in Maps app
    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: item.location)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = item.name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    /// Shares item information
    private func shareItem() {
        // Share implementation would go here
        let shareText = "Check out \(item.name) on the AR Heritage & Wildlife Explorer app!"
        
        // Placeholder for actual UIActivityViewController implementation
        print("Sharing: \(shareText)")
    }
}

// MARK: - Preview

struct SiteWildlifeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SiteWildlifeDetailView(item: DetailItem(
                name: "Sigiriya",
                type: .heritageSite,
                images: ["sigiriya1", "sigiriya2", "sigiriya3"],
                description: "Sigiriya or Sinhagiri is an ancient rock fortress located in the northern Matale District near the town of Dambulla in the Central Province, Sri Lanka. The name refers to a site of historical and archaeological significance that is dominated by a massive column of rock around 180 metres (590 ft) high.",
                location: CLLocationCoordinate2D(latitude: 7.9570, longitude: 80.7603),
                funFacts: [
                    "Sigiriya rock is actually a hardened magma plug from an extinct volcano.",
                    "The gardens of Sigiriya are among the oldest landscaped gardens in the world.",
                    "The Mirror Wall at Sigiriya has ancient graffiti dating back to the 8th century.",
                    "There are over 1,500 frescoes on the western face of the rock."
                ],
                conservationStatus: nil,
                historicalPeriod: "5th Century AD",
                arModelAvailable: true
            ))
        }
    }
}

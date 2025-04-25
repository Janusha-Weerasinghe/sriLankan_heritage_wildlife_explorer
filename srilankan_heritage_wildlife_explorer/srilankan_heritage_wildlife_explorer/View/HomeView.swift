import SwiftUI
import MapKit

// MARK: - Models

/// Model representing items on home screen (heritage sites and wildlife)
struct ExplorerItem: Identifiable {
    let id = UUID()
    let name: String
    let type: ItemType
    let image: String
    let shortDescription: String
    let isPopular: Bool
    let location: CLLocationCoordinate2D
    
    enum ItemType: String {
        case heritageSite = "Heritage Site"
        case wildlife = "Wildlife"
        
        var icon: String {
            switch self {
            case .heritageSite: return "building.columns.fill"
            case .wildlife: return "leaf.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .heritageSite: return .orange
            case .wildlife: return .green
            }
        }
    }
}

// MARK: - View Components

struct HomeComponents {
    
    struct CategoryScroll: View {
        @Binding var selectedCategory: String
        let categories = ["All", "Heritage", "Wildlife", "Popular", "Nearby"]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            withAnimation {
                                selectedCategory = category
                            }
                        }) {
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedCategory == category ?
                                              Color.accentColor : Color(UIColor.secondarySystemBackground))
                                )
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    struct FeaturedCard: View {
        let item: ExplorerItem
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack(alignment: .bottomLeading) {
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(12)
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: item.type.icon)
                            Text(item.type.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(item.type.color.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        Text(item.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(item.shortDescription)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                    }
                    .padding()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .shadow(radius: 4)
        }
    }
    
    struct ItemCard: View {
        let item: ExplorerItem
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: item.type.icon)
                                .font(.caption)
                            Text(item.type.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(item.type.color)
                        
                        Text(item.name)
                            .fontWeight(.semibold)
                        
                        Text(item.shortDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    struct SectionHeader: View {
        let title: String
        let showMoreAction: () -> Void
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: showMoreAction) {
                    HStack(spacing: 2) {
                        Text("See All")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Home Screen View

struct HomeView: View {
    @State private var selectedCategory = "All"
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showNotifications = false
    @State private var selectedItem: ExplorerItem?
    @State private var showingDetailView = false
    
    let featuredItems: [ExplorerItem] = [
        ExplorerItem(
            name: "Sigiriya",
            type: .heritageSite,
            image: "sigiriya1",
            shortDescription: "Ancient rock fortress with spectacular frescoes and landscaped gardens",
            isPopular: true,
            location: CLLocationCoordinate2D(latitude: 7.9570, longitude: 80.7603)
        ),
        ExplorerItem(
            name: "Sri Lankan Elephant",
            type: .wildlife,
            image: "elephant1",
            shortDescription: "The largest of Asian elephant subspecies found across Sri Lanka",
            isPopular: true,
            location: CLLocationCoordinate2D(latitude: 7.8742, longitude: 80.6511)
        )
    ]
    
    let popularItems: [ExplorerItem] = [
        ExplorerItem(
            name: "Polonnaruwa",
            type: .heritageSite,
            image: "polonnaruwa1",
            shortDescription: "Ancient city known for its well-preserved ruins",
            isPopular: true,
            location: CLLocationCoordinate2D(latitude: 7.9403, longitude: 81.0188)
        ),
        ExplorerItem(
            name: "Sri Lankan Leopard",
            type: .wildlife,
            image: "leopard1",
            shortDescription: "Endangered big cat native to the forests of Sri Lanka",
            isPopular: true,
            location: CLLocationCoordinate2D(latitude: 6.4019, longitude: 81.3180)
        ),
        ExplorerItem(
            name: "Anuradhapura",
            type: .heritageSite,
            image: "anuradhapura1",
            shortDescription: "Sacred ancient city with dagobas and sacred trees",
            isPopular: true,
            location: CLLocationCoordinate2D(latitude: 8.3114, longitude: 80.4037)
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        searchBar
                        
                        HomeComponents.CategoryScroll(selectedCategory: $selectedCategory)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HomeComponents.SectionHeader(title: "Featured", showMoreAction: {})
                            
                            TabView {
                                ForEach(featuredItems) { item in
                                    HomeComponents.FeaturedCard(item: item) {
                                        selectedItem = item
                                        showingDetailView = true
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .frame(height: 250)
                            .tabViewStyle(PageTabViewStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HomeComponents.SectionHeader(title: "Popular Destinations", showMoreAction: {})
                            
                            VStack(spacing: 12) {
                                ForEach(popularItems) { item in
                                    HomeComponents.ItemCard(item: item) {
                                        selectedItem = item
                                        showingDetailView = true
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
//                        VStack(alignment: .leading, spacing: 16) {
//                            HomeComponents.SectionHeader(title: "Upcoming Events", showMoreAction: {})
//                            
//                            Text("No upcoming events")
//                                .foregroundColor(.secondary)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .padding()
//                        }
                    }
                    .padding(.vertical)
                }
                
                NavigationLink(
                    destination: detailViewForSelectedItem,
                    isActive: $showingDetailView,
                    label: { EmptyView() }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AR Explorer")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNotifications = true
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search places or wildlife", text: $searchText)
                    .foregroundColor(.primary)
                
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
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    private var detailViewForSelectedItem: some View {
        Group {
            if let item = selectedItem {
                VStack {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                    
                    Text(item.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    
                    Text(item.shortDescription)
                        .font(.body)
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle(item.name)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("No item selected")
            }
        }
    }
}

// MARK: - Preview

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

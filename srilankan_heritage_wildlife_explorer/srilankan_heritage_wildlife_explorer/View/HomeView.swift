//
//  HomeScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-09.
//


import SwiftUI

/// Main home screen of the application that provides access to primary features
struct HomeView: View {
    // MARK: - Properties
    
    /// Environment objects
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var locationManager: LocationManager
    
    /// State variables
    @State private var selectedTab = 0
    @State private var showNotifications = false
    @State private var searchQuery = ""
    @State private var isSearching = false
    

    
    /// Featured exploration options
    private let featuredItems = [
        ExplorationItem(id: "1", title: "Sigiriya Rock", image: "sigiriya", type: .heritage),
        ExplorationItem(id: "2", title: "Yala Safari", image: "yala", type: .wildlife),
        ExplorationItem(id: "3", title: "Polonnaruwa", image: "polonnaruwa", type: .heritage),
        ExplorationItem(id: "4", title: "Sri Lankan Elephants", image: "elephant", type: .wildlife)
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            welcomeSection
                            //searchBar
                            nearbyExplorationSection
                            featuredExplorationSection
                            popularCategoriesSection
                        }
                        .padding(.horizontal)
                    }
                    
                    //customTabBar
                    // Reusable Tab Bar
                CustomTabBar(selectedTab:$selectedTab)
//                    SearchBar (searchQuery: <#T##Binding<String>#>, isSearching: <#T##Binding<Bool>#>)
                }
            }
//            .navigationBarHidden(true)
//            .sheet(isPresented: $showNotifications) {
//                NotificationCenterScreen()
//            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showNotifications) {
                Text("🔔 Notification Center (Mock)")
                    .font(.title)
                    .padding()
            }
//            .sheet(isPresented: $isSearching) {
//                SearchResultsScreen(searchQuery: searchQuery)
//            }
//            .sheet(isPresented: $isSearching) {
//                            SearchResultsScreen(searchQuery: searchQuery)
                      }
        }
    }
    
    // MARK: - UI Components
    
    /// Header with user profile and notification button
    private var headerView: some View {
        HStack {
//            NavigationLink(destination: UserProfileView()) {
//                Image("UserAvatar")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 40, height: 40)
//                    .clipShape(Circle())
//            }
            
                        NavigationLink(destination: Text("🏠 Profile Screen")) {
                            Image("UserAvatar")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
            
            
            Spacer()
            
            Text("AR Explorer")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            //comment because  errors
            
//            Button(action: { showNotifications = true }) {
//                ZStack {
//                    Image(systemName: "bell.fill")
//                        .font(.title3)
//                        .foregroundColor(.primary)
//                    
//                    // Notification badge
//                    Circle()
//                        .fill(Color.red)
//                        .frame(width: 10, height: 10)
//                        .offset(x: 8, y: -8)
//                }
//            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
    
    /// Welcome message with user name
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Welcome back, Adam!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Discover Sri Lanka's heritage and wildlife")
                .foregroundColor(.secondary)
        }
        .padding(.top, 10)
    }
    
    /// Search bar component
//    private var searchBar: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//
//            TextField("Search for places, animals...", text: $searchQuery)
//                .onSubmit {
//                    if !searchQuery.isEmpty {
//                        isSearching = true
//                    }
//                }
//
//            if !searchQuery.isEmpty {
//                Button(action: { searchQuery = "" }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .padding(.vertical, 10)
//    }
//
///// Search bar component
//private var searchBar: some View {
//    HStack {
//        Image(systemName: "magnifyingglass")
//            .foregroundColor(.gray)
//
//        TextField("Search for places, animals...", text: $searchQuery)
//            .onSubmit {
//                if !searchQuery.isEmpty {
//                    isSearching = true
//                }
//            }
//
//        if !searchQuery.isEmpty {
//            Button(action: { searchQuery = "" }) {
//                Image(systemName: "xmark.circle.fill")
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//    .padding()
//    .background(Color(.systemGray6))
//    .cornerRadius(12)
//    .padding(.vertical, 10)
//}

    /// Section showing nearby exploration options
    private var nearbyExplorationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Nearby")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
//                NavigationLink(destination: MapViewScreen()) {
//                    Text("View Map")
//                        .font(.subheadline)
//                        .foregroundColor(Color("PrimaryColor"))
//                }
                                NavigationLink(destination: Text("🏠 Map Screen")) {
                                    Text("View Map")
                                        .font(.subheadline)
                                        .foregroundColor(Color("PrimaryColor"))
                                }
            }
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    ForEach(featuredItems.shuffled().prefix(3)) { item in
//                        NearbyCard(item: item)
//                    }
//                }
   //         }
        }
    }
    
    /// Section showing featured exploration options
    private var featuredExplorationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Featured Explorations")
                .font(.title2)
                .fontWeight(.bold)
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 20) {
//                    ForEach(featuredItems) { item in
//                        FeaturedCard(item: item)
//                    }
//                }
//            }
        }
        .padding(.top, 5)
    }
    
    /// Section showing popular categories
    private var popularCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Popular Categories")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                CategoryButton(title: "Heritage Sites", icon: "building.columns.fill", color: .blue) {
                    // Navigate to Heritage screen
                }
                
                CategoryButton(title: "Wildlife", icon: "leaf.fill", color: .green) {
                    // Navigate to Wildlife screen
                }
                
                CategoryButton(title: "AR Experiences", icon: "arkit", color: .purple) {
                    // Navigate to AR screen
                }
                
                CategoryButton(title: "Favorites", icon: "heart.fill", color: .red) {
                    // Navigate to Favorites screen
                }
            }
        }
        .padding(.vertical, 10)
    }
    
//    /// Custom tab bar at the bottom
//    private var customTabBar: some View {
//        HStack {
//            TabBarButton(title: "Home", icon: "house.fill", isSelected: selectedTab == 0) {
//                selectedTab = 0
//            }
//
//            TabBarButton(title: "Heritage", icon: "building.columns", isSelected: selectedTab == 1) {
//                selectedTab = 1
//            }
//
//            // Center AR button
//            Button(action: { /* Open AR camera */ }) {
//                ZStack {
//                    Circle()
//                        .fill(Color("PrimaryColor"))
//                        .frame(width: 60, height: 60)
//                        .shadow(radius: 2)
//
//                    Image(systemName: "camera.viewfinder")
//                        .font(.system(size: 25))
//                        .foregroundColor(.white)
//                }
//            }
//            .offset(y: -20)
//
//            TabBarButton(title: "Wildlife", icon: "pawprint", isSelected: selectedTab == 2) {
//                selectedTab = 2
//            }
//
//            TabBarButton(title: "Profile", icon: "person.fill", isSelected: selectedTab == 3) {
//                selectedTab = 3
//            }
//        }
//        .padding(.horizontal)
//        .padding(.top, 15)
//        .padding(.bottom, 5)
//        .background(Color(.systemBackground))
//        .cornerRadius(25, corners: [.topLeft, .topRight])
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
//    }
    

// MARK: - Supporting UI Components

/// Model for exploration items
struct ExplorationItem: Identifiable {
    let id: String
    let title: String
    let image: String
    let type: ExploreType
    
    enum ExploreType {
        case heritage
        case wildlife
    }
}

///// Card showing a nearby place
//struct NearbyCard: View {
//    let item: ExplorationItem
//    
//    var body: some View {
//        NavigationLink(destination:
//            item.type == .heritage ?
//                HeritageSiteDetailView(siteId: item.id) :
//                WildlifeDetailScreen(wildlifeId: item.id)
//        ) {
//            ZStack(alignment: .bottomLeading) {
//                Image(item.image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 180, height: 120)
//                    .cornerRadius(15)
//                    .overlay(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                        .cornerRadius(15)
//                    )
//                
//                VStack(alignment: .leading) {
//                    Text(item.title)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                    
//                    Text("2.5 km away")
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding(.horizontal, 12)
//                .padding(.vertical, 10)
//            }
//        }
//    }
//}
//
///// Card showing a featured exploration option
//struct FeaturedCard: View {
//    let item: ExplorationItem
//    
//    var body: some View {
//        NavigationLink(destination:
//            item.type == .heritage ?
//                HeritageSiteDetailView(siteId: item.id) :
//                WildlifeDetailScreen(wildlifeId: item.id)
//        ) {
//            VStack(alignment: .leading) {
//                Image(item.image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 280, height: 180)
//                    .cornerRadius(15)
//                
//                Text(item.title)
//                    .font(.headline)
//                    .padding(.top, 5)
//                
//                Text(item.type == .heritage ? "Historical Site" : "Wildlife")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            .frame(width: 280)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}

/// Button for a category
struct CategoryButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.2))
                    .cornerRadius(10)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

/// Tab bar button
//struct TabBarButton: View {
//    let title: String
//    let icon: String
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 4) {
//                Image(systemName: icon)
//                    .font(.system(size: isSelected ? 22 : 20))
//                    .foregroundColor(isSelected ? Color("PrimaryColor") : .gray)
//
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(isSelected ? Color("PrimaryColor") : .gray)
//            }
//            .frame(maxWidth: .infinity)
//        }
//    }
//}

// MARK: - Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
           
    }
}

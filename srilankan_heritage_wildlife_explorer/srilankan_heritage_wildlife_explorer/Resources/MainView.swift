//
//  MainView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-26.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if selectedTab == 0 {
                    NavigationView {
                        HomeView()
                            .navigationBarTitle("Explore", displayMode: .large)
                    }
                } else if selectedTab == 1 {
                    NavigationView {
                        MapView()
                            .navigationBarTitle("Map", displayMode: .large)
                    }
                } else if selectedTab == 2 {
                    NavigationView {
                        FavoritesListScreen()
                            .navigationBarTitle("Favourites", displayMode: .large)
                    }
                } else if selectedTab == 3 {
                    NavigationView {
                        ProfileView()
                            .navigationBarTitle("Profile", displayMode: .large)
                    }
                }
            }

            CustomTabBar(selectedTab: $selectedTab)
        }

    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

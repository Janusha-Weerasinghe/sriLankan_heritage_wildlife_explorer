//
//  CustomTabBar.swift
//  test
//
//  Created by janusha on 2025-04-23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            TabBarButton(title: "Home", icon: "house.fill", isSelected: selectedTab == 0) {
                selectedTab = 0
            }

            TabBarButton(title: "Heritage", icon: "building.columns", isSelected: selectedTab == 1) {
                selectedTab = 1
            }


            TabBarButton(title: "Wildlife", icon: "pawprint", isSelected: selectedTab == 2) {
                selectedTab = 2
            }

            TabBarButton(title: "Profile", icon: "person.fill", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .padding(.horizontal)
        .padding(.top, 15)
        .padding(.bottom, 5)
        .background(Color(.systemBackground))
        .cornerRadius(25, corners: [.topLeft, .topRight])
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

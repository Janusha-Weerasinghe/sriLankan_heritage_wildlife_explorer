//
//  TabBarButton.swift
//  test
//
//  Created by janusha on 2025-04-23.
//

import SwiftUI

struct TabBarButton: View {
    var title: String
    var icon: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .accentColor : .gray)

                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
    }
}


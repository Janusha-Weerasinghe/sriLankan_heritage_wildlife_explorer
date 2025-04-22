//
//  PopularSitesView.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by janusha on 2025-04-22.
//

import SwiftUI

struct PopularSitesView: View {
    let sites: [HeritageSite]
    let onSiteTapped: (HeritageSite) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular Heritage Sites")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sites) { site in
                        HeritageSiteCard(site: site) {
                            onSiteTapped(site)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
}

//
//  WildExplorerView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//
import SwiftUI

struct WildlifeExplorerView: View {
    @EnvironmentObject var viewModel: HeritageViewModel
    @State private var searchText = ""
    
    var filteredItems: [WildlifeItem] {
        if searchText.isEmpty {
            return viewModel.wildlifeItems
        } else {
            return viewModel.wildlifeItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ForEach(filteredItems) { item in
                            WildlifeItemCard(item: item)
                                .onTapGesture {
                                    viewModel.selectItem(item)
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sri Lanka Wildlife")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search Wildlife")
            .fullScreenCover(isPresented: $viewModel.showARTutorial) {
                ARTutorialView()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.showARView) {
                if let item = viewModel.selectedItem as? WildlifeItem {
                    ARViewContainer(wildlife: item)
                        .environmentObject(viewModel)
                        .ignoresSafeArea()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


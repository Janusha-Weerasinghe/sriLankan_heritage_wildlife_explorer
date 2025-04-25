//
//  HeritageExplorationView.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//


import SwiftUI

struct HeritageExplorationView: View {
    @EnvironmentObject var viewModel: HeritageViewModel
    @State private var searchText = ""
    
    var filteredItems: [HeritageItem] {
        if searchText.isEmpty {
            return viewModel.heritageItems
        } else {
            return viewModel.heritageItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
                            HeritageItemCard(item: item)
                                .onTapGesture {
                                    viewModel.selectItem(item)
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sri Lanka Heritage")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search heritage sites")
            .fullScreenCover(isPresented: $viewModel.showARTutorial) {
                ARTutorialView()
                    .environmentObject(viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.showARView) {
                if let item = viewModel.selectedItem as? HeritageItem {
                    ARViewContainer(item: item)
                        .environmentObject(viewModel)
                        .ignoresSafeArea()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HeritageExplorationView_Previews: PreviewProvider {
    static var previews: some View {
        HeritageExplorationView()
    }
}

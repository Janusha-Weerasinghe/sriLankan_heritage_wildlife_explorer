import SwiftUI

struct SearchBar: View {
    @Binding var searchQuery: String
    @Binding var isSearching: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search for places, animals...", text: $searchQuery)
                .onSubmit {
                    if !searchQuery.isEmpty {
                        isSearching = true
                    }
                }

            if !searchQuery.isEmpty {
                Button(action: { searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.vertical, 10)
    }
}

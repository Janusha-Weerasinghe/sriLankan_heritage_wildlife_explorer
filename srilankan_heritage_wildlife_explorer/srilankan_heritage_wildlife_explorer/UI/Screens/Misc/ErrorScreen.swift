//
//  ErrorScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI

// MARK: - Network Status Monitor
/// Monitors network connectivity status
class NetworkMonitor: ObservableObject {
    // MARK: - Published Properties
    @Published var isConnected = true
    
    // MARK: - Initialization
    init() {
        // In a real app, implement actual network monitoring
        // For demonstration, we'll simulate network changes
        checkConnection()
    }
    
    // MARK: - Methods
    /// Simulates checking network connection
    /// In a real app, use NWPathMonitor for actual implementation
    func checkConnection() {
        // Simulation for demo purposes
        isConnected = true
    }
    
    /// Toggles connection status (for testing UI)
    func toggleConnectionStatus() {
        isConnected.toggle()
    }
}

// MARK: - Offline Data Manager
/// Manages cached data for offline use
class OfflineDataManager {
    // MARK: - Properties
    static let shared = OfflineDataManager()
    
    // MARK: - Methods
    /// Checks if content is available offline
    func isContentAvailableOffline(contentId: String) -> Bool {
        // In a real app, check if content exists in Core Data or local storage
        return UserDefaults.standard.bool(forKey: "offline_\(contentId)")
    }
    
    /// Saves content for offline use
    func saveContentForOffline(contentId: String, contentData: Data) {
        // In a real app, save to Core Data or local storage
        UserDefaults.standard.set(true, forKey: "offline_\(contentId)")
    }
    
    /// Removes offline content
    func removeOfflineContent(contentId: String) {
        // In a real app, remove from Core Data or local storage
        UserDefaults.standard.removeObject(forKey: "offline_\(contentId)")
    }
}

// MARK: - Error Type Enum
/// Defines different types of errors that can occur in the app
enum AppErrorType {
    case network
    case dataFetch
    case authentication
    case unknown
    
    var title: String {
        switch self {
        case .network:
            return "Network Error"
        case .dataFetch:
            return "Data Error"
        case .authentication:
            return "Authentication Error"
        case .unknown:
            return "Unexpected Error"
        }
    }
    
    var message: String {
        switch self {
        case .network:
            return "Unable to connect to the server. Please check your internet connection."
        case .dataFetch:
            return "Unable to load data. Please try again later."
        case .authentication:
            return "Your session has expired. Please sign in again."
        case .unknown:
            return "Something went wrong. Please try again later."
        }
    }
    
    var icon: String {
        switch self {
        case .network:
            return "wifi.slash"
        case .dataFetch:
            return "exclamationmark.triangle"
        case .authentication:
            return "lock.shield"
        case .unknown:
            return "questionmark.circle"
        }
    }
}

// MARK: - Error View
/// A reusable component to display different types of errors
struct ErrorView: View {
    // MARK: - Properties
    let errorType: AppErrorType
    let retryAction: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: errorType.icon)
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text(errorType.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(errorType.message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button {
                retryAction()
            } label: {
                Text("Try Again")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Offline Mode View
/// View displayed when the app is in offline mode
struct OfflineModeView: View {
    // MARK: - Properties
    @ObservedObject var networkMonitor: NetworkMonitor
    let refreshAction: () -> Void
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Offline badge
                HStack {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.white)
                    
                    Text("Offline Mode")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange)
                .cornerRadius(20)
                
                // Info message
                VStack(spacing: 15) {
                    Image(systemName: "cloud.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("You're currently offline")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("You can still access your saved sites and wildlife information.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .padding()
                
                // Available offline content
                VStack(alignment: .leading, spacing: 15) {
                    Text("Available Offline")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Sample offline items - in a real app, fetch from Core Data
                    ForEach(1...3, id: \.self) { item in
                        offlineItemView(title: "Saved Item \(item)")
                    }
                    
                    Button {
                        networkMonitor.toggleConnectionStatus()
                        refreshAction()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Check Connection")
                        }
                        .font(.system(.body, weight: .medium))
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
    
    // MARK: - Helper Views
    /// Creates a view for an offline item
    private func offlineItemView(title: String) -> some View {
        HStack {
            Image(systemName: "doc.fill")
                .foregroundColor(.blue)
            
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - Content View with Error & Offline handling
struct ContentViewWithErrorHandling: View {
    // MARK: - Properties
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var isLoading = false
    @State private var errorType: AppErrorType? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Main content when online and no errors
            if networkMonitor.isConnected && errorType == nil {
                Text("Main App Content")
                    .onAppear {
                        // Load data when view appears
                        loadData()
                    }
            }
            // Error view
            else if let error = errorType {
                ErrorView(errorType: error) {
                    // Retry action
                    retryLoadingData()
                }
            }
            // Offline mode
            else if !networkMonitor.isConnected {
                OfflineModeView(networkMonitor: networkMonitor) {
                    // Refresh action
                    checkNetworkAndLoadData()
                }
            }
            
            // Loading indicator
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
    }
    
    // MARK: - Methods
    /// Loads data based on network status
    private func loadData() {
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            // Check if we have network connection
            if !networkMonitor.isConnected {
                // No error, just offline mode
                errorType = nil
            } else {
                // Success - no error
                errorType = nil
            }
        }
    }
    
    /// Retry loading data after an error
    private func retryLoadingData() {
        errorType = nil
        loadData()
    }
    
    /// Checks network status and loads data
    private func checkNetworkAndLoadData() {
        isLoading = true
        
        // Simulate network check
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            if networkMonitor.isConnected {
                loadData()
            }
        }
    }
}

// MARK: - Preview Provider
struct ErrorOfflineViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorView(errorType: .network) {}
                .previewDisplayName("Network Error")
            
            OfflineModeView(networkMonitor: NetworkMonitor()) {}
                .previewDisplayName("Offline Mode")
            
            ContentViewWithErrorHandling()
                .previewDisplayName("Content View")
        }
    }
}

//
//  SettingsScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//

import SwiftUI

/// Enumeration for app theme options
enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
    
    /// Returns the appropriate system image name for the theme
    var iconName: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

/// Enumeration for app language options
enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case sinhala = "සිංහල" // Sinhala
    case tamil = "தமிழ்" // Tamil
    
    var id: String { self.rawValue }
}

/// Model for app settings
struct AppSettings {
    var theme: AppTheme = .system
    var language: AppLanguage = .english
    var notificationsEnabled: Bool = true
    var locationTrackingEnabled: Bool = true
    var useMetricSystem: Bool = true
    var saveContentOffline: Bool = true
    var autoPlayAudio: Bool = false
    var highQualityAR: Bool = true
    var dataUsage: DataUsageSetting = .wifi
    
    enum DataUsageSetting: String, CaseIterable, Identifiable {
        case always = "Always"
        case wifi = "Wi-Fi Only"
        case never = "Never"
        
        var id: String { self.rawValue }
    }
}

/// ViewModel for managing app settings
class SettingsViewModel: ObservableObject {
    @Published var settings = AppSettings()
    
    // In a real app, these methods would interact with UserDefaults or other persistence
    
    /// Save all settings to persistent storage
    func saveSettings() {
        // Implementation would store to UserDefaults or other storage
        print("Settings saved: \(settings)")
    }
    
    /// Reset settings to default values
    func resetToDefaults() {
        settings = AppSettings()
    }
}

/// Main Settings Screen View
struct SettingsScreen: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Appearance Settings Section
                Section(header: Text("Appearance")) {
                    // Theme picker
                    Picker("Theme", selection: $viewModel.settings.theme) {
                        ForEach(AppTheme.allCases) { theme in
                            Label(theme.rawValue, systemImage: theme.iconName)
                                .tag(theme)
                        }
                    }
                    
                    // Language picker
                    Picker("Language", selection: $viewModel.settings.language) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                }
                
                // Content & Privacy Settings Section
                Section(header: Text("Content & Privacy")) {
                    Toggle("Enable Notifications", isOn: $viewModel.settings.notificationsEnabled)
                    
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("Notification Preferences")
                    }
                    .disabled(!viewModel.settings.notificationsEnabled)
                    
                    Toggle("Location Tracking", isOn: $viewModel.settings.locationTrackingEnabled)
                        .onChange(of: viewModel.settings.locationTrackingEnabled) { newValue in
                            if newValue {
                                // In a real app, would request location permissions here
                                print("Location permissions would be requested")
                            }
                        }
                }
                
                // Content Display Settings Section
                Section(header: Text("Content Display")) {
                    Toggle("Use Metric System", isOn: $viewModel.settings.useMetricSystem)
                    
                    Toggle("Save Content for Offline", isOn: $viewModel.settings.saveContentOffline)
                    
                    Toggle("Auto-play Audio Guides", isOn: $viewModel.settings.autoPlayAudio)
                    
                    Picker("Data Usage", selection: $viewModel.settings.dataUsage) {
                        ForEach(AppSettings.DataUsageSetting.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }
                
                // AR Settings Section
                Section(header: Text("AR Experience")) {
                    Toggle("High Quality AR Models", isOn: $viewModel.settings.highQualityAR)
                        .onChange(of: viewModel.settings.highQualityAR) { newValue in
                            // Additional logic could be added here to warn about performance
                            if newValue {
                                print("High quality AR enabled - may affect performance")
                            }
                        }
                    
                    NavigationLink(destination: ARSettingsView()) {
                        Text("Advanced AR Settings")
                    }
                }
                
                // Account & Support Section
                Section(header: Text("Account & Support")) {
                    NavigationLink(destination: AccountView()) {
                        Label("Account Information", systemImage: "person.circle")
                    }
                    
                    NavigationLink(destination: HelpSupportView()) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                }
                
                // Reset Settings Section
                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset to Default Settings")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveSettings()
                    }
                }
            }
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Reset Settings"),
                    message: Text("Are you sure you want to reset all settings to default values?"),
                    primaryButton: .destructive(Text("Reset")) {
                        viewModel.resetToDefaults()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

/// Placeholder view for notification settings
struct NotificationSettingsView: View {
    var body: some View {
        List {
            Toggle("Heritage Sites Nearby", isOn: .constant(true))
            Toggle("Wildlife Sightings", isOn: .constant(true))
            Toggle("Content Updates", isOn: .constant(false))
            Toggle("Conservation Events", isOn: .constant(true))
        }
        .navigationTitle("Notification Settings")
    }
}

/// Placeholder view for AR settings
struct ARSettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("AR Performance")) {
                Picker("AR Detail Level", selection: .constant(2)) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
                
                Picker("People Occlusion", selection: .constant(1)) {
                    Text("Off").tag(0)
                    Text("On").tag(1)
                }
                
                Picker("Environment Texturing", selection: .constant(1)) {
                    Text("Off").tag(0)
                    Text("On").tag(1)
                }
            }
            
            Section(header: Text("Model Interaction")) {
                Toggle("Allow Model Scaling", isOn: .constant(true))
                Toggle("Enable Audio Effects", isOn: .constant(true))
                Toggle("Show Information Markers", isOn: .constant(true))
            }
        }
        .navigationTitle("AR Settings")
    }
}

/// Placeholder view for account settings
struct AccountView: View {
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("John Doe")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text("john.doe@example.com")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button("Edit Profile") {
                    // Edit profile action
                }
                
                Button("Change Password") {
                    // Change password action
                }
                
                Button("Sign Out") {
                    // Sign out action
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Account")
    }
}

/// Placeholder view for help and support
struct HelpSupportView: View {
    var body: some View {
        List {
            NavigationLink(destination: Text("FAQ Content")) {
                Label("Frequently Asked Questions", systemImage: "questionmark.circle")
            }
            
            NavigationLink(destination: Text("Tutorial Content")) {
                Label("App Tutorial", systemImage: "book.fill")
            }
            
            NavigationLink(destination: Text("Contact Form")) {
                Label("Contact Support", systemImage: "envelope.fill")
            }
            
            NavigationLink(destination: Text("About Content")) {
                Label("About This App", systemImage: "info.circle")
            }
        }
        .navigationTitle("Help & Support")
    }
}

/// Placeholder view for privacy policy
struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Last updated: April 2025")
                    .foregroundColor(.secondary)
                
                Text("This is a placeholder for the privacy policy content. In a real application, this would contain the full privacy policy text explaining how user data is collected, stored, and used.")
                
                Text("Topics typically covered would include:")
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Label("Information Collection", systemImage: "doc.text")
                    Label("Data Usage", systemImage: "chart.bar")
                    Label("Location Tracking", systemImage: "location")
                    Label("Camera Usage", systemImage: "camera")
                    Label("Third-Party Services", systemImage: "link")
                    Label("Data Retention", systemImage: "clock")
                    Label("User Rights", systemImage: "person.text.rectangle")
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

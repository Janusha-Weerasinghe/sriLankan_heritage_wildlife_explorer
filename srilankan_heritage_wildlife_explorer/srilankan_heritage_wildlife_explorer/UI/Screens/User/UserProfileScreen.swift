//
//  UserProfileScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//



import SwiftUI

struct UserProfileView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    @AppStorage("userFullName") private var userFullName = ""
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("userCountry") private var userCountry = "Sri Lanka"
    @State private var isEditMode = false
    @State private var tempFullName = ""
    @State private var tempEmail = ""
    @State private var tempCountry = ""
    @State private var showingImagePicker = false
    @State private var profileImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Statistics data - in a real app, this would come from Core Data or an API
    private let visitedSites = 12
    private let savedFavorites = 24
    private let completedTours = 8
    
    // Country options for picker
    private let countries = ["Sri Lanka", "India", "USA", "UK", "Australia", "Japan", "Canada", "Other"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile header with image
                    profileHeader
                    
                    // Statistics section
                    statisticsSection
                    
                    // User information section
                    userInformationSection
                    
                    // Account actions section
                    accountActionsSection
                    
                    // App settings shortcuts
                    appSettingsSection
                }
                .padding()
            }
            .navigationTitle(isEditMode ? "Edit Profile" : "My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if isEditMode {
                            cancelEdit()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: isEditMode ? "xmark" : "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isEditMode {
                            saveChanges()
                        } else {
                            startEdit()
                        }
                    }) {
                        Text(isEditMode ? "Save" : "Edit")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                // Image picker would go here
                Text("Image Picker Placeholder")
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Profile Updated"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - UI Components
    
    /// Profile header with image and edit button
    private var profileHeader: some View {
        VStack {
            ZStack {
                // Profile image
                Group {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(radius: 5)
                
                // Edit button that appears in edit mode
                if isEditMode {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
                    }
                    .offset(x: 40, y: 40)
                }
            }
            .padding(.bottom, 8)
            
            // User name
            Text(isEditMode ? tempFullName : userFullName)
                .font(.title2)
                .fontWeight(.bold)
            
            // User email
            Text(isEditMode ? tempEmail : userEmail)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    /// User statistics section
    private var statisticsSection: some View {
        HStack(spacing: 20) {
            statisticItem(count: visitedSites, label: "Sites Visited", icon: "map.fill")
            
            Divider()
                .frame(height: 40)
            
            statisticItem(count: savedFavorites, label: "Favorites", icon: "heart.fill")
            
            Divider()
                .frame(height: 40)
            
            statisticItem(count: completedTours, label: "Tours", icon: "checkmark.circle.fill")
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    /// Helper function to create consistent statistic items
    private func statisticItem(count: Int, label: String, icon: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 18))
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    /// User information fields section
    private var userInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.headline)
                .padding(.bottom, 4)
            
            if isEditMode {
                // Editable fields
                profileEditField(title: "Full Name", text: $tempFullName, icon: "person.fill")
                profileEditField(title: "Email", text: $tempEmail, icon: "envelope.fill")
                
                // Country picker
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    Picker("Country", selection: $tempCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.vertical, 8)
            } else {
                // Display-only fields
                profileInfoField(title: "Full Name", value: userFullName, icon: "person.fill")
                profileInfoField(title: "Email", value: userEmail, icon: "envelope.fill")
                profileInfoField(title: "Country", value: userCountry, icon: "globe")
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    /// Helper function for displaying profile information fields
    private func profileInfoField(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value.isEmpty ? "Not set" : value)
                    .font(.body)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Helper function for editable profile fields
    private func profileEditField(title: String, text: Binding<String>, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextField("Enter \(title.lowercased())", text: text)
                    .font(.body)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Section for account-related actions
    private var accountActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.headline)
                .padding(.bottom, 4)
            
            accountActionButton(title: "Achievement Badges", icon: "medal.fill") {
                // Navigate to badges
                print("Opening badges")
            }
            
            accountActionButton(title: "Learning Progress", icon: "chart.bar.fill") {
                // Navigate to learning progress
                print("Opening learning progress")
            }
            
            accountActionButton(title: "Change Password", icon: "lock.fill") {
                // Show change password screen
                print("Opening change password")
            }
            
            accountActionButton(title: "Logout", icon: "arrow.right.square.fill", isDestructive: true) {
                // Perform logout
                print("Logging out")
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    /// Helper function for account action buttons
    private func accountActionButton(title: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(isDestructive ? .red : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Section for app settings shortcuts
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App Settings")
                .font(.headline)
                .padding(.bottom, 4)
            
            settingsShortcutButton(title: "Notification Preferences", icon: "bell.fill") {
                // Navigate to notification settings
                print("Opening notification settings")
            }
            
            settingsShortcutButton(title: "Privacy Settings", icon: "hand.raised.fill") {
                // Navigate to privacy settings
                print("Opening privacy settings")
            }
            
            settingsShortcutButton(title: "App Appearance", icon: "paintbrush.fill") {
                // Navigate to appearance settings
                print("Opening appearance settings")
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    /// Helper function for settings shortcut buttons
    private func settingsShortcutButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Functions
    
    /// Start editing profile information
    private func startEdit() {
        // Copy current values to temporary state
        tempFullName = userFullName
        tempEmail = userEmail
        tempCountry = userCountry
        
        // Enter edit mode
        isEditMode = true
    }
    
    /// Save profile changes
    private func saveChanges() {
        // Validate email format
        if !isValidEmail(tempEmail) && !tempEmail.isEmpty {
            alertMessage = "Please enter a valid email address."
            showingAlert = true
            return
        }
        
        // Save updated values
        userFullName = tempFullName
        userEmail = tempEmail
        userCountry = tempCountry
        
        // Exit edit mode
        isEditMode = false
        
        // Show confirmation
        alertMessage = "Your profile has been updated successfully."
        showingAlert = true
    }
    
    /// Cancel editing and revert changes
    private func cancelEdit() {
        // Revert temporary values
        tempFullName = ""
        tempEmail = ""
        tempCountry = ""
        
        // Exit edit mode
        isEditMode = false
    }
    
    /// Validate email format using a simple regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Preview
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

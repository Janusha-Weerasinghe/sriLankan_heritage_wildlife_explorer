//
//  FeedbackScreen.swift
//  srilankan_heritage_wildlife_explorer
//
//  Created by Janusha 023 on 2025-04-22.
//


import SwiftUI

struct FeedbackContactView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    @State private var feedbackType = FeedbackType.general
    @State private var feedbackText = ""
    @State private var name = ""
    @State private var email = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Enums
    enum FeedbackType: String, CaseIterable, Identifiable {
        case general = "General Feedback"
        case bugReport = "Bug Report"
        case featureRequest = "Feature Request"
        case contentIssue = "Content Issue"
        
        var id: String { self.rawValue }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header image
                    headerImage
                    
                    // Feedback type selector
                    feedbackTypeSelector
                    
                    // Feedback text input
                    feedbackTextInput
                    
                    // Contact information section
                    contactInfoSection
                    
                    // Support options
                    supportOptions
                    
                    // Submit button
                    submitButton
                }
                .padding()
            }
            .navigationTitle("Feedback & Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Thank You!"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - UI Components
    
    /// Header image for the feedback section
    private var headerImage: some View {
        Image(systemName: "bubble.left.and.bubble.right.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 80)
            .foregroundColor(.blue)
            .padding()
            .frame(maxWidth: .infinity)
    }
    
    /// Selection for feedback type
    private var feedbackTypeSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What kind of feedback do you have?")
                .font(.headline)
            
            Picker("Feedback Type", selection: $feedbackType) {
                ForEach(FeedbackType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    /// Text input for detailed feedback
    private var feedbackTextInput: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tell us more")
                .font(.headline)
            
            TextEditor(text: $feedbackText)
                .frame(minHeight: 150)
                .padding(8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    /// Section for user contact information
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your contact information")
                .font(.headline)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 4)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.vertical, 4)
        }
    }
    
    /// Additional support options
    private var supportOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Other ways to reach us")
                .font(.headline)
            
            supportOptionButton(
                icon: "envelope.fill",
                title: "Email Support",
                subtitle: "support@arheritage.com",
                action: { contactViaEmail() }
            )
            
            supportOptionButton(
                icon: "phone.fill",
                title: "Call Support",
                subtitle: "+94 112 345 678",
                action: { contactViaPhone() }
            )
            
            supportOptionButton(
                icon: "questionmark.circle.fill",
                title: "FAQ",
                subtitle: "View frequently asked questions",
                action: { openFAQ() }
            )
        }
    }
    
    /// Helper function to create consistent support option buttons
    private func supportOptionButton(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Submit button for feedback form
    private var submitButton: some View {
        Button(action: submitFeedback) {
            Text("Submit Feedback")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.vertical)
        }
    }
    
    // MARK: - Functions
    
    /// Validates form input and handles feedback submission
    private func submitFeedback() {
        // Basic validation
        guard !feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please provide feedback details before submitting."
            showingAlert = true
            return
        }
        
        // Save feedback to Core Data or prepare for API submission
        saveFeedback()
        
        // Show confirmation to user
        alertMessage = "Thank you for your feedback! We'll review it shortly."
        showingAlert = true
        
        // Reset form
        resetForm()
    }
    
    /// Save feedback data to persistent storage or prepare for API submission
    private func saveFeedback() {
        // Here you would:
        // 1. Create a Feedback model object
        // 2. Save to Core Data or prepare API request
        // 3. Handle success/failure
        
        // This is a placeholder for the actual implementation
        print("Saving feedback: \(feedbackType.rawValue)")
        print("Content: \(feedbackText)")
        print("From: \(name) <\(email)>")
        
        // TODO: Implement actual data persistence logic
    }
    
    /// Reset form after submission
    private func resetForm() {
        feedbackType = .general
        feedbackText = ""
        name = ""
        email = ""
    }
    
    /// Contact support via email
    private func contactViaEmail() {
        // Implementation to open mail client
        // This would use UIApplication.shared.open with a mailto URL
        // Sample implementation:
        guard let url = URL(string: "mailto:support@arheritage.com") else { return }
        UIApplication.shared.open(url)
    }
    
    /// Contact support via phone
    private func contactViaPhone() {
        // Implementation to open phone dialer
        // This would use UIApplication.shared.open with a tel URL
        // Sample implementation:
        guard let url = URL(string: "tel:+94112345678") else { return }
        UIApplication.shared.open(url)
    }
    
    /// Open FAQ section
    private func openFAQ() {
        // Implementation to navigate to FAQ section
        // This would typically use NavigationLink or present a new view
        print("Opening FAQ section")
        // TODO: Implement navigation to FAQ
    }
}

// MARK: - Preview
struct FeedbackContactView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackContactView()
    }
}

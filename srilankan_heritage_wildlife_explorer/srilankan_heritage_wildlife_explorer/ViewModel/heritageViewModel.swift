//
//  heritageViewModel.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//


import Foundation
import Combine
import CoreLocation
import UserNotifications

class HeritageViewModel: ObservableObject {
    @Published var heritageItems: [HeritageItem] = []
    @Published var wildlifeItems: [WildlifeItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedItem: Any?
    @Published var showARTutorial: Bool = false
    @Published var showARView: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    
    init() {
        setupLocationManager()
        loadData()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadData() {
        isLoading = true
        
        // Load heritage items
        DataService.shared.fetchHeritageItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.heritageItems = items
            }
            .store(in: &cancellables)
        
        // Load wildlife items
        DataService.shared.fetchWildlifeItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.wildlifeItems = items
            }
            .store(in: &cancellables)
    }
    
    func selectItem(_ item: Any) {
        selectedItem = item
    }
    
    func showARViewForItem(_ item: Any) {
        // Check if tutorial has been shown before
        let tutorialShown = UserDefaults.standard.bool(forKey: "ARTutorialShown")
        
        if !tutorialShown {
            showARTutorial = true
            UserDefaults.standard.set(true, forKey: "ARTutorialShown")
        } else {
            proceedToARView()
        }
    }
    
    func proceedToARView() {
        showARTutorial = false
        showARView = true
        
        if let item = selectedItem as? HeritageItem {
            scheduleLocationNotification(item: item)
        } else if let item = selectedItem as? WildlifeItem {
            // For wildlife, we might notify about where to find them
            scheduleWildlifeNotification(item: item)
        }
    }
    
    func scheduleLocationNotification(item: HeritageItem) {
        guard let currentLocation = locationManager.location else { return }
        
        let distance = currentLocation.distance(from: item.location.clLocation)
        let distanceInKm = distance / 1000
        
        let content = UNMutableNotificationContent()
        content.title = "Exploring \(item.name)"
        content.body = "You are approximately \(String(format: "%.1f", distanceInKm)) km away from \(item.name)."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWildlifeNotification(item: WildlifeItem) {
        let content = UNMutableNotificationContent()
        content.title = "Discover \(item.name)"
        content.body = "Best places to spot: \(item.commonLocations.joined(separator: ", "))"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func dismissARView() {
        showARView = false
    }
}

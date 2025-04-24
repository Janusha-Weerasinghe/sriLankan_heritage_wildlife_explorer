//
//  DataService.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//

import Foundation
import Combine

enum DataError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
}

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func fetchHeritageItems() -> AnyPublisher<[HeritageItem], Error> {
        guard let url = Bundle.main.url(forResource: "heritage_data", withExtension: "json") else {
            return Fail(error: DataError.invalidURL).eraseToAnyPublisher()
        }
        
        return Just(url)
            .tryMap { url -> Data in
                try Data(contentsOf: url)
            }
            .decode(type: [HeritageItem].self, decoder: jsonDecoder)
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return DataError.decodingError
                } else {
                    return DataError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchWildlifeItems() -> AnyPublisher<[WildlifeItem], Error> {
        guard let url = Bundle.main.url(forResource: "wildlife_data", withExtension: "json") else {
            return Fail(error: DataError.invalidURL).eraseToAnyPublisher()
        }
        
        return Just(url)
            .tryMap { url -> Data in
                try Data(contentsOf: url)
            }
            .decode(type: [WildlifeItem].self, decoder: jsonDecoder)
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return DataError.decodingError
                } else {
                    return DataError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// Services/LocationService.swift
import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func distanceToLocation(_ location: CLLocation) -> Double? {
        guard let userLocation = userLocation else { return nil }
        return userLocation.distance(from: location)
    }
}


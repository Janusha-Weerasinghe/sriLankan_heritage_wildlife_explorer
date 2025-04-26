//
//  CLLocation+Extention.swift
//  test
//
//  Created by Janusha 023 on 2025-04-24.
//
import CoreLocation

extension CLLocation {
    func userFriendlyDescription() -> String? {
        let geocoder = CLGeocoder()
        var result: String?
        
      
        let semaphore = DispatchSemaphore(value: 0)
        
        geocoder.reverseGeocodeLocation(self) { placemarks, error in
            defer { semaphore.signal() }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                var components: [String] = []
                
                if let locality = placemark.locality {
                    components.append(locality)
                }
                
                if let administrativeArea = placemark.administrativeArea {
                    components.append(administrativeArea)
                }
                
                if let country = placemark.country {
                    components.append(country)
                }
                
                result = components.joined(separator: ", ")
            }
        }
        
        // Wait for geocoding to complete
        _ = semaphore.wait(timeout: .now() + 2.0)
        return result
    }
}

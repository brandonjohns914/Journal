//
//  LocationView-ViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/13/24.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI
extension LocationView {
    @Observable
    class ViewModel {
         private(set) var locations: [Location]
        var selectedPlace: Location?
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func loadLocations() {
            do {
                let data = try Data(contentsOf: savePath)
                let decodedLocations = try JSONDecoder().decode([Location].self, from: data)
                print(decodedLocations)
            } catch {
                print("Unable to load data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func delete(at point: CLLocationCoordinate2D) {
            if var location = locations.remove(where: {$0.latitude == point.latitude}) {
                
                location.latitude = point.latitude
                
                locations.append(location)
            }
        }
    
        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }
        
       
    }
}


extension Array {
    mutating func remove(where condition: (Element) -> Bool) -> Element? {
        guard let index = firstIndex(where: condition) else {
            return nil
        }
        
        return remove(at: index)
    }
}

//
//  EditLocationView-ViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import Foundation
import MapKit
import SwiftUI

extension EditLocationView {
    @Observable
    class ViewModel {
       
        var name: String
        var description: String
        
        
        var location: Location
        
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
        }
        
        func createNewLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
  
    }
}


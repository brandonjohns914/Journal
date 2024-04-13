//
//  Location-CoreDataHelpers.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import Foundation
import MapKit

extension LocationCoreData {
    
    var locationName: String {
        get {nameLocationCoreData ?? ""}
        set { nameLocationCoreData = newValue }
    }
    
    var locationDescription: String {
        get {descriptionLocactionCoreData ?? "" }
        set {descriptionLocactionCoreData = newValue}
    }
    
    var locationID : UUID {
        idLocationCoreData ?? UUID()
    }
    
   
    
    var locationLatitude: Double {
        get { latitudeLocationCoreData }
        set { latitudeLocationCoreData = newValue}
    
    }
    
    var locationLongitude: Double {
        get {longitudeLocationCoreData}
        set {longitudeLocationCoreData = newValue}
    }
    
    
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: locationLatitude  , longitude: locationLongitude)
    }
   
    static var example: LocationCoreData {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let location = LocationCoreData(context: viewContext)
        
        location.idLocationCoreData = UUID()
        location.locationName = "Buckingham Palace"
        location.locationDescription = "Lit by over 40,000 lightbulbs."
        location.locationLatitude = 51.501
        location.locationLongitude = -0.141
        return location
    }
    
}

extension LocationCoreData: Comparable {
    public static func < (lhs: LocationCoreData, rhs: LocationCoreData) -> Bool {
        let left = lhs.locationName.localizedLowercase
        let right = rhs.locationName.localizedLowercase
        
        if left == right {
            return lhs.locationID.uuidString < rhs.locationID.uuidString
        } else {
            return left < right
        }
    }
    
    
}

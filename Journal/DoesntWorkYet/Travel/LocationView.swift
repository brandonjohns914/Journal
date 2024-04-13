//
//  LocationView.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State private var  selectedPlace: Location?
    @State private var locations = [Location]()
    @AppStorage("mapStyle") private var mapStyle = "standard"
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: EntryJournal
    
    
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    var body: some View {
     
            VStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(mapStyle == "standard" ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            addLocation(at: coordinate)
                        }
                        
                    }
                    .sheet(item: $selectedPlace) { place in
                        EditLocationView(location: place) {
                            update(location: $0)
                        }
                    }
                }
                Picker("Map mode", selection: $mapStyle) {
                    Text("Standard")
                        .tag("standard")

                    Text("Hybrid")
                        .tag("hybrid")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

            }
     
    }
    
    func addLocation(at point: CLLocationCoordinate2D) {
        let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
        locations.append(newLocation)
        save()
    }
    
    func update(location: Location) {
        guard let selectedPlace else { return }
        
        if let index = locations.firstIndex(of: selectedPlace) {
            locations[index] = location
            save()
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(entry.saveLocations)
            try data.write(to: entry.saveLocations, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
    }
}

#Preview {
    LocationView(entry: .example)
}

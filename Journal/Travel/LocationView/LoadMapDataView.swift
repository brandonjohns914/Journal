//
//  LoadMapDataView.swift
//  Journal
//
//  Created by Brandon Johns on 4/13/24.
//

import SwiftUI
import MapKit
extension LocationView {
    struct LoadMapDataView: View {
        @State private var viewModel = ViewModel()
        var body: some View {
            List{
                ForEach(viewModel.locations)  { location in
                    
                    Button(location.name, systemImage: "map") {
                        viewModel.selectedPlace = location
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditLocationView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                           
            }
        }
        
       
      
        
    }
    
}


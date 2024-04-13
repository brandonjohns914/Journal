//
//  EditLocationView.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import SwiftUI
import MapKit

struct EditLocationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    var onSave: (Location) -> Void
     

       var body: some View {
           NavigationStack {
               Form {
                   Section {
                       TextField("Place name", text: $viewModel.name)
                       TextField("Description", text: $viewModel.description)
                   }
               }
               .navigationTitle("Place details")
               .toolbar {
                   Button("Save") {
                       let newLocation = viewModel.createNewLocation()

                       onSave(newLocation)
                       dismiss()
                   }
               }
           }
       }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
   
}

#Preview {
    EditLocationView(location: .example) {_ in}
}

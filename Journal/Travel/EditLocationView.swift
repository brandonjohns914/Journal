//
//  EditLocationView.swift
//  Journal
//
//  Created by Brandon Johns on 4/13/24.
//

import SwiftUI

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
                Section("Local Wiki Descriptions") {
                    
                    VStack {
                        Toggle("Show Near by Locations", isOn: $viewModel.showingWiki)
                                            
                                            if viewModel.showingWiki {
                                                WikiEditLocationView(location: viewModel.location)
                                            }
                        
                        
                    }
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
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
        
    }
        /// Acessing the values to be changed
        /// @escaping the function is being stashed away to be used later
        /// onSave is only called when the button is pressed
        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.onSave = onSave
            _viewModel = State(initialValue: ViewModel(location: location))
        }
        
    }


//#Preview {
//    EditLocationView(location: .example) { _ in }
//}

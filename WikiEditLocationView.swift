//
//  WikiEditLocationView.swift
//  Journal
//
//  Created by Brandon Johns on 4/13/24.
//

import Foundation
import SwiftUI

extension EditLocationView {
    struct WikiEditLocationView: View {
        
        
        @State private var viewModel: ViewModel
        

        
        var body: some View {
            Section {
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
        init(location: Location) {
          
            _viewModel = State(initialValue: ViewModel(location: location))
        }
        
    }
}

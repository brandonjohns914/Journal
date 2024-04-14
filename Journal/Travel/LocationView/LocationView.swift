//
//  LocationView.swift
//  Journal
//
//  Created by Brandon Johns on 4/13/24.
//

import SwiftUI
import MapKit


struct LocationView: View {
 
    @State private var viewModel = ViewModel()
    
        var body: some View {
            NavigationStack{
                VStack {
                    Section {
                        NavigationLink {
                            MapView()
                        } label: {
                            Label("Select locations on the map", systemImage: "map")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                    .padding()
                        }
                    }
                    .padding()
                    Section {
                        NavigationLink{
                            LoadMapDataView()
                        } label: {
                            Label("View Saved Locations", systemImage: "mappin.circle.fill")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding()
                        }
                    }
                   
                }
                .navigationTitle("Map Details")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(colors: [.blue, .teal, .green, .gray ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea())
            }
    }
}

#Preview {
    LocationView()
}

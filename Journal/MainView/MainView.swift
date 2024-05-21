//
//  MainView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: ViewModel
    
    let smartFilters: [Filter] = [.all, .recent]
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }
            .foregroundStyle(.blue)
            
            Section("Topics") {
                ForEach(viewModel.topicFilters) { filter in
                    UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
                    
                }
                .onDelete(perform: viewModel.delete)
                .foregroundStyle(.green)
       
            }
//            Section("Travel") {
//                NavigationLink("MAP") {
//                    LocationView()
//                }
//            }
            
        }
        .alert("Rename Topic", isPresented: $viewModel.renamingTopic) {
            Button("OK", action: viewModel.completeRename)
            Button("Cancel", role: .cancel) {}
            TextField("New Name", text: $viewModel.topicName)
        }
        .toolbar(content: MainViewToolbar.init)
        .navigationTitle("Filters")
        
    }
    
   
}

#Preview {
    MainView(dataController: .preview)
        
}

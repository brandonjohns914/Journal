//
//  ContentView.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedEntry) {
            ForEach(viewModel.dataController.entriesForSelectedFilter()){ entry in
                EntryRows(entry: entry)
            }
            .onDelete(perform: viewModel.delete)
        }
        .searchable(
            text: $viewModel.filterText,
            tokens: $viewModel.filterTokens,
            suggestedTokens: .constant(viewModel.suggestedFilterTokens),
            prompt: "Select a Topic or write in the entry name"
        ) { topic in
            Text(topic.topicName)
        }
        .toolbar {
        ContentViewToolbar()
        }
        .navigationTitle("Entries")
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
      
}

#Preview {
    ContentView(dataController: .preview)
}

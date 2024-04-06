//
//  ContentView.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedEntry) {
            ForEach(viewModel.dataController.entriesForSelectedFilter()) { entry in
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
        .onAppear(perform: askForReview)
        .onOpenURL(perform: openURL)
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }
    
    func openURL(_ url: URL) {
        if url.absoluteString.contains("newEntry") {
            viewModel.dataController.newEntry()
        }
    }
}

#Preview {
    ContentView(dataController: .preview)
}

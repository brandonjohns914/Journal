//
//  ContentView.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    #if !os(watchOS)
    @Environment(\.requestReview) var requestReview
    #endif
    
    @StateObject var viewModel: ViewModel
    
    private let newEntryActivity = "BJ914.Journal.newEntry"
    
    var body: some View {
        List(selection: $viewModel.selectedEntry) {
            ForEach(viewModel.dataController.entriesForSelectedFilter()) { entry in
                #if os(watchOS)
                EntryRowWatch(entry: entry)
                #else
                EntryRows(entry: entry)
                #endif
            }
            .onDelete(perform: viewModel.delete)
        }
        .macFrame(minWidth: 220)
#if !os(watchOS)
        .searchable(
            text: $viewModel.filterText,
            tokens: $viewModel.filterTokens,
            suggestedTokens: .constant(viewModel.suggestedFilterTokens),
            prompt: "Select a Topic or write in the entry name"
        ) { topic in
            Text(topic.topicName)
        }
        #endif 
        .toolbar {
        ContentViewToolbar()
        }
        .navigationTitle("Entries")
        .onAppear(perform: askForReview)
        .onOpenURL(perform: viewModel.openURL)
        .userActivity(newEntryActivity) { activity in
            #if !os(macOS)
            activity.isEligibleForPrediction = true
            #endif 
            activity.title = "New Entry"
        }
        .onContinueUserActivity(newEntryActivity, perform: resumeActivity)
        .background(LinearGradient(colors: [.blue, .teal, .green, .gray ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea())
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    func askForReview() {
#if !os(watchOS)
        if viewModel.shouldRequestReview {
            requestReview()
        }
        #endif 
    }
    
    func resumeActivity(_ userActivity: NSUserActivity) {
        viewModel.dataController.newEntry()
    }
}

#Preview {
    ContentView(dataController: .preview)
}

//
//  ContentView.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
   
    var body: some View {
        List(selection: $dataController.selectedEntry) {
            ForEach(dataController.entriesForSelectedFilter()){ entry in
                EntryRows(entry: entry)
            }
            .onDelete(perform: delete)
        }
        .searchable(
            text: $dataController.filterText,
            tokens: $dataController.filterTokens,
            suggestedTokens: .constant(dataController.suggestedFilterTokens),
            prompt: "Select a Topic or write in the entry name"
        ) { topic in
            Text(topic.topicName)
        }
        .toolbar {
        ContentViewToolbar()
        }
        .navigationTitle("Entries")
    }
    
    /// Deletes Entries  from the view 
    func delete(_ offsets: IndexSet) {
        
        let entries = dataController.entriesForSelectedFilter()
        for offset in offsets {
            let item = entries[offset]
            dataController.delete(item)
        }
    }   
}

#Preview {
    ContentView()
}

//
//  EntryRowsViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/4/24.
//

import Foundation

extension EntryRows {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        let entry: EntryJournal
        
        var iconOpactiy: Double {
            entry.priority == 2 ? 1 : 0
        }
        
        var iconIdentifier: String {
            entry.priority == 2 ? "\(entry.entryName) High Priority" : ""
        }
        
        var accessibilityHint: String {
            entry.priority == 2 ? "High priority" : ""
        }
        
        var creationDate: String {
            entry.entryCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        var accessibilityCreationDate: String {
            entry.entryCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        init(entry: EntryJournal) {
            self.entry = entry
        }
        
        // Connect directly to the Entry so viewModel can access the properties 
        subscript<Value>(dynamicMember keyPath: KeyPath<EntryJournal, Value>) -> Value {
            entry[keyPath: keyPath]
        }
    }
}

//
//  EntryRowsViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/4/24.
//

import Foundation

extension EntryRows {
    class ViewModel: ObservableObject {
        let entry: Entry
        
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
        
        init(entry: Entry) {
            self.entry = entry
        }
        
    }
}

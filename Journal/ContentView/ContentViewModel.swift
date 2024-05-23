//
//  ContentViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/4/24.
//

import Foundation
import CoreData

extension ContentView {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        var shouldRequestReview: Bool {
            if dataController.count(for: Topic.fetchRequest() ) >= 5 {
                let reviewRequestCount = UserDefaults.standard.integer(forKey: "reviewRequestCount")
                UserDefaults.standard.set(reviewRequestCount + 1, forKey: "reviewRequestCount")
                
                if reviewRequestCount.isMultiple(of: 10) {
                    return true
                }
            }
            return false
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
   
        // Connect directly to the dataController so viewModel can access the properties
        subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
            dataController[keyPath: keyPath]
        }
        
        // can now read and write to dataController
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
            get { dataController[keyPath: keyPath] }
            set { dataController[keyPath: keyPath] = newValue }
        }
        
        /// Deletes Entries  from the view
        func delete(_ offsets: IndexSet) {
            
            let entries = dataController.entriesForSelectedFilter()
            for offset in offsets {
                let item = entries[offset]
                dataController.delete(item)
            }
        }
        
        func openURL(_ url: URL) {
            if url.absoluteString.contains("newEntry") {
                dataController.newEntry()
            } else  if let entry = dataController.entry(with: url.absoluteString) {
              dataController.selectedEntry = entry
                dataController.selectedFilter = .all
            }
        }
    }
    
    
}

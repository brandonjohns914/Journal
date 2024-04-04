//
//  ContentViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/4/24.
//

import Foundation
import CoreData

extension ContentView {
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
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
}

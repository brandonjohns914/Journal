//
//  MainViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/3/24.
//

import CoreData
import Foundation
import SwiftUI

extension MainView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        
        var dataController: DataController
        
        /// Fetching updating changes so the View cannot see it
        private let topicsController: NSFetchedResultsController<Topic>
        @Published var topics = [Topic]()
        
        @Published var topicToRename: Topic?
        @Published var renamingTopic = false
        @Published var topicName = ""
        
        
        var topicFilters: [Filter] {
            topics.map{ topic in
                Filter(id: topic.topicID, name: topic.topicName, icon: "pencil.line", topic: topic)
            }
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            let request = Topic.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Topic.name, ascending: true)]
            
            
            // get the fetch request 
            topicsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            // NSObject requirement
            super.init()
            
            // tell me when core data has updated
            topicsController.delegate = self
            
            do {
                try topicsController.performFetch()
                
                topics = topicsController.fetchedObjects ?? []
            } catch {
                print("failed to fetch topics")
            }
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let item = topics[offset]
                dataController.delete(item)
            }
        }
        func delete(_ filter: Filter) {
            guard let topic = filter.topic else {return}
            dataController.delete(topic)
            dataController.save()
        }
        
        func rename(_ filter: Filter){
            topicToRename = filter.topic
            topicName = filter.name
            renamingTopic = true
        }
        
        func completeRename() {
            topicToRename?.name = topicName
            dataController.save()
        }
    }
}

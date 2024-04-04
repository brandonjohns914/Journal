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
    class ViewModel: ObservableObject {
        
        var dataController: DataController
        
        @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var topics: FetchedResults<Topic>
        
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

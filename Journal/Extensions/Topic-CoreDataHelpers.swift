//
//  Topic-CoreDataHelpers.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import Foundation

extension Topic {
    
    /// filters all active entries the ones that havent been completed
    var topicActiveEntries: [EntryJournal] {
        let result = entries?.allObjects as? [EntryJournal] ?? []
        return result.filter { $0.completed == false}
    }
    
    /// returns all entries assicated wtih that Topic
    var topicEntries: [EntryJournal] {
        let result = entries?.allObjects as? [EntryJournal] ?? []
        return result.sorted()
    }
    var topicID: UUID {
        id ?? UUID()
    }
    
    var topicName: String {
        name ?? ""
    }
    
    static var example: Topic {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let topic = Topic(context: viewContext)
        topic.id = UUID()
        topic.name = "Example Topic"
        
        return topic
    }
}

extension Topic: Comparable {
    public static func <(lhs: Topic, rhs: Topic) -> Bool {
        let left = lhs.topicName.localizedLowercase
        let right = rhs.topicName.localizedLowercase
        
        if left == right {
            return lhs.topicID.uuidString < rhs.topicID.uuidString
        } else {
            return left < right
        }
    }
}

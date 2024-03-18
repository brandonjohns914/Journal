//
//  Entry-CoreDataHelpers.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import Foundation

extension Entry {
    
    /// Creates an array of all the topics by their name
    var entryTopicsList: String {
        guard let topics else {return "No Topics"}
        
        if topics.count == 0 {
            return "No Topics"
        } else {
            return entryTopics.map(\.topicName).formatted()
        }
    }
    
    var entryStatus: String {
        if completed {
            return "Finished"
        } else {
            return "Still Working"
        }
    }
    
    /// returns all topics sorted
    var entryTopics: [Topic] {
        let result = topics?.allObjects as? [Topic] ?? []
        return result.sorted()
    }
    var entryName: String {
        get { entryNameCoreData ?? "" }
        set { entryNameCoreData = newValue}
    }
    
    var entryDescription: String {
        get { entryDescriptionCoreData ?? ""}
        set { entryDescriptionCoreData = newValue}
    }
    
    var entryCreationDate: Date {
        creationDate ?? .now
    }
    var entryModifcationDate: Date {
        modificationDate ?? .now
    }
    
    static var example: Entry {
        let controller = DataController(inMemory: true)
        
        let viewContext = controller.container.viewContext
        
        let entry = Entry(context: viewContext)
        entry.entryName = "Example Entry"
        entry.entryDescription = "This is an example entry"
        entry.priority = 2
        entry.creationDate = .now
        return entry
    }
}

extension Entry: Comparable {
    public static func < (lhs: Entry, rhs: Entry) -> Bool {
        let left = lhs.entryName.localizedLowercase
        let right = rhs.entryName.localizedLowercase
        
        if left == right {
            return lhs.entryCreationDate < rhs.entryCreationDate
        } else {
            return left < right
        }
    }
}



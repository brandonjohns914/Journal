//
//  Entry-CoreDataHelpers.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import Foundation

extension EntryJournal {
    
    /// Creates an array of all the topics by their name
    var entryTopicsList: String {
        let noTopics = NSLocalizedString("No Topics", comment: "The user has not created any topics yet.")
        guard let topics else {return noTopics}
        
        if topics.count == 0 {
            return noTopics
        } else {
            return entryTopics.map(\.topicName).formatted()
        }
    }
    
    var entryStatus: String {
        if completed {
            return NSLocalizedString("Finished", comment: "This entry has been fished by the user.")
        } else {
            return NSLocalizedString("Still Working", comment: "This entry is currently unfinished.")
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
    
    var entryReminderTime: Date {
        get {reminderTime ?? .now }
        set { reminderTime = newValue }
    }
    
 
    
    static var example: EntryJournal {
        let controller = DataController(inMemory: true)
        
        let viewContext = controller.container.viewContext
        
        let entry = EntryJournal(context: viewContext)
        entry.entryName = "Example Entry"
        entry.entryDescription = "This is an example entry"
        entry.priority = 2
        entry.creationDate = .now
        return entry
    }
}

extension EntryJournal: Comparable {
    public static func < (lhs: EntryJournal, rhs: EntryJournal) -> Bool {
        let left = lhs.entryName.localizedLowercase
        let right = rhs.entryName.localizedLowercase
        
        if left == right {
            return lhs.entryCreationDate < rhs.entryCreationDate
        } else {
            return left < right
        }
    }
}



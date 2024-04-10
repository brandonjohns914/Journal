//
//  DataController.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import Foundation
import CoreData
import PhotosUI
import SwiftUI
import StoreKit
import WidgetKit


enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
    case name = "entryNameCoreData"
}

enum Status  {
    case all, open, closed
}



class DataController: ObservableObject {
    ///Loads/Stores/Syncs local data with iCloud
    let container: NSPersistentCloudKitContainer
    
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?
    
    /// The UserDefaults suite where we're saving user data.
    let defaults: UserDefaults
    
    ///StoreKit products loaded for the store
    @Published var products = [Product]()
    
    /// Default selected filter to all
    @Published var selectedFilter: Filter? = Filter.all
    
    /// The selected Entry in the view the user is looking at.
    @Published var selectedEntry: EntryJournal?
    
    @Published var filterText = ""
    @Published var filterTokens = [Topic]()
    @Published var filterEnabled = false
    @Published var filterPriority = -1
    @Published var filterStatus = Status.all
    
    @Published var sortType = SortType.dateCreated
    @Published var sortNewestFirst = true
    @Published var sortByName = true
    
    /// To stop over saving to save hardware resources
    private var saveTask: Task<Void, Error>?
    private var storeTask: Task<Void, Never>?
    
    var suggestedFilterTokens: [Topic] {
        let trimmedFilterText = String(filterText).trimmingCharacters(in: .whitespaces)
        let request = Topic.fetchRequest()
        
        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }
        
        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }
        
        return managedObjectModel
    }()
    
    
    
    /// Initializer to load Main (data model) for previewing
    /// - Parameter inMemory: when true memory is created and when false memory is created on disk
    /// - Parameter defaults: The UserDefaults suite where user data should be stored
    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        storeTask = Task {
            await monitorTransactions()
        }
        
        
        /// For Testing and previewing purposes, we create a
        /// temporary, in-memory database by writting to /dev/null
        /// so our data is destroied after the app finishes running
        if inMemory {
            /// Writes the memory to nowhere
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        } else {
            let groupID = "group.BJ914.Journal"
            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appending(path: "Main.sqlite")
            }
        }
        
        ///Combines local and remote changes
        ///prefers local changes over remote changes
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        /// calls remoteStoreChange function anytime a change has happened
        /// watches iCloud for all changes to male sure local UI is
        /// in sync when remote changes happen
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentHistoryTrackingKey
        )
        
        
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )
        
        
        /// Loads any memory on the database onto disk.
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(
                        forStoreWith: description,
                        coordinator: coordinator
                    )

                    self?.spotlightDelegate?.startSpotlightIndexing()
                }
            }

//            #if DEBUG
//            if CommandLine.arguments.contains("enable-testing") {
//                self?.deleteAll()
//                UIView.setAnimationsEnabled(false)
//            }
//            #endif
        }
    }
    /// Creates sample data that can be used for testing purposes
    func createSampleData() {
        /// holds all active objects in memory as they are worked on.
        /// only adds them to persistent storaged when asked to.
        let viewContext = container.viewContext
        
        for topicIndex in 1...3 {
            let topic = Topic(context: viewContext)
            topic.id = UUID()
            topic.name = "Topic \(topicIndex)"
            
            for entryIndex in 1...5 {
                let entry = EntryJournal(context: viewContext)
                entry.entryNameCoreData = "Entry \(topicIndex)-\(entryIndex)"
                entry.entryDescriptionCoreData = "Description of the Topic goes here"
                entry.creationDate = .now
                entry.completed = Bool.random()
                entry.priority = Int16.random(in: 0...2)
                topic.addToEntries(entry)
            }
        }
        /// save all objects to persistent storage.
        try? viewContext.save()
    }
    
    /// for previewing the sample data
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    /// Checks for any changes that has happened to the data to write it to disk
    func save() {
        saveTask?.cancel()
        
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            /// forces all widget to update 
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    /// Waits three seconds before calling save.
    func queueSave() {
        saveTask?.cancel()
        
        saveTask = Task { @MainActor in
            print("Queueing Save")
            try await Task.sleep(for: .seconds(3))
            save()
            print("Saved!")
        }
    }
    
    
    /// Delete a specific Entry or Topic from the viewContext
    /// announce that change has happened to the data and the views need to update
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    ///Batch delete to delete all sample data created for testing purposes
    /// must return the id of what was deleted so it can check and merge the memory
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? [] ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Topic.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = EntryJournal.fetchRequest()
        delete(request2)
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    /// Sorts all the topics and computes which topics arent assigned to the entry
    func missingTopics(from entry: EntryJournal) -> [Topic] {
        let request = Topic.fetchRequest()
        let allTopics = (try? container.viewContext.fetch(request)) ?? []
        
        let allTopicsSet = Set(allTopics)
        let difference = allTopicsSet.symmetricDifference(entry.entryTopics)
        
        return difference.sorted()
    }
    
    /// Creates an entry predicate array that sorts and filters based on
    /// topic, modificationdate, name, desciption, priority, and completed.
    func entriesForSelectedFilter() ->  [EntryJournal] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()
        
        if let topic = filter.topic {
            let topicPredicate = NSPredicate(format: "topics CONTAINS %@", topic)
            predicates.append(topicPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }
        
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
        
        if trimmedFilterText.isEmpty == false {
            let namePredicate = NSPredicate(format: "entryNameCoreData CONTAINS[c] %@", trimmedFilterText)
            let descriptionPredicate = NSPredicate(format: "entryDescriptionCoreData CONTAINS[c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, descriptionPredicate])
            predicates.append(combinedPredicate)
        }
        
        if filterTokens.isEmpty == false {
            let tokenPredicate = NSPredicate(format: "ANY topics IN %@", filterTokens)
            predicates.append(tokenPredicate)
        }
        
        if filterEnabled {
            if filterPriority >= 0 {
                let priorityFilter = NSPredicate(format: "priority = %d", filterPriority)
                predicates.append(priorityFilter)
            }
            
            if filterStatus != .all {
                let lookForClosed = filterStatus == .closed
                
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForClosed))
                predicates.append(statusFilter)
            }
        }
        
        let request = EntryJournal.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let newestFirstSortDescriptor = NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)
        let nameSortDescriptor = NSSortDescriptor(key: sortType.rawValue, ascending: sortByName)
        
        request.sortDescriptors = [newestFirstSortDescriptor, nameSortDescriptor]
        
        let allEntries = (try? container.viewContext.fetch(request)) ?? []
        
        return allEntries
        
    }
    
    func newEntry() {
        let entry = EntryJournal(context: container.viewContext)
        entry.entryName = "New Entry"
        entry.creationDate = .now
        entry.priority = 1
        
        
        if let topic = selectedFilter?.topic {
            entry.addToTopics(topic)
        }
        
                
        
        selectedEntry = entry
        
        save()
    }
    
    
    
    
    func newTopic() -> Bool {
        var shouldCreate = fullVersionUnlocked
        
        if shouldCreate == false {
            // check how many topics we currently have
            shouldCreate = count(for: Topic.fetchRequest()) < 3
        }
        
        guard shouldCreate else {
            return false
        }
        
        let topic = Topic(context: container.viewContext)
        topic.id = UUID()
        topic.name = "New Topic"
        save()
        return true 
    }
    
    /// Counts the fetch requests and removes the optionals
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
   
    func entry(with uniqueIdentifier: String) -> EntryJournal? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }

        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? EntryJournal
    }
    
    
    func fetchRequestForTopEntries(count: Int) -> NSFetchRequest<EntryJournal> {
        let request = EntryJournal.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
        
        request.sortDescriptors = [
               NSSortDescriptor(keyPath: \EntryJournal.priority, ascending: false)
           ]

           request.fetchLimit = count
           return request
    }
    
    func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
    
    
    
}

    /*
     // before inapp purchases
     func newTopic() {
         let topic = Topic(context: container.viewContext)
         topic.id = UUID()
         topic.name = "New Topic"
         save()
     }
     */

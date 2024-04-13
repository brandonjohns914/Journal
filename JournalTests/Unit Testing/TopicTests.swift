//
//  TopicTests.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import CoreData
import XCTest

@testable import Journal

final class TopicTests: BaseTestCase {

    func testCreatingTagsAndIssues() {
        let count = 10
        let entryCount = count * count

        for _ in 0..<count {
            let topic = Topic(context: managedObjectContext)

            for _ in 0..<count {
                let entry = EntryJournal(context: managedObjectContext)
                topic.addToEntries(entry)
                
            }
        }

        XCTAssertEqual(dataController.count(for: Topic.fetchRequest()), count, "Expected \(count) topics.")
        XCTAssertEqual(dataController.count(for: EntryJournal.fetchRequest()), entryCount, "Expected \(entryCount) entries.")
    }

    func testDeletingTopicDoesNotDeleteEntries() throws {
        dataController.createSampleData()
        
        let request = NSFetchRequest<Topic>(entityName: "Topic")
        let topics = try managedObjectContext.fetch(request)
        
        dataController.delete(topics[0])
        
        XCTAssertEqual(dataController.count(for: Topic.fetchRequest()), 4, "Expected 4 topicss after deleting 1.")
        XCTAssertEqual(dataController.count(for: EntryJournal.fetchRequest()), 50, "Expected 50 entries after deleting a topic.")
    }

}

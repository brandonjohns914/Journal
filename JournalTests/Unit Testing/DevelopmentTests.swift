//
//  DevelopmentTests.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import CoreData
import XCTest

@testable import Journal

final class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() {
        dataController.createSampleData()
        
        XCTAssertEqual(dataController.count(for: Topic.fetchRequest()), 5, "There should be 5 sample topics.")
        XCTAssertEqual(dataController.count(for: EntryJournal.fetchRequest()), 50, "There should be 50 sample entries.")
    }
    
    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Topic.fetchRequest()), 0, "deleteAll() should leave 0 topics.")
        XCTAssertEqual(dataController.count(for: EntryJournal.fetchRequest()), 0, "deleteAll() should leave 0 entries.")
    }
    
    func testExampleTagHasNoIssues() {
        let topic = Topic.example
        XCTAssertEqual(topic.entries?.count, 0, "The example topic should have 0 entries.")
    }

    func testExampleIssueIsHighPriority() {
        let entry = EntryJournal.example
        XCTAssertEqual(entry.priority, 2, "The example entry should be high priority.")
    }
}

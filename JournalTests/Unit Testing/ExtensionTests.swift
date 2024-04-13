//
//  ExtensionTests.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import CoreData
import XCTest

@testable import Journal

final class ExtensionTests: BaseTestCase {

    func testEntryNameUnwrap() {
        let entry = EntryJournal(context: managedObjectContext)

        entry.entryNameCoreData = "Example entry"
        XCTAssertEqual(entry.entryName, "Example entry", "Changing entry should also change entryname.")

        entry.entryName = "Updated entry"
        
        XCTAssertEqual(entry.entryNameCoreData, "Updated entry", "Changing entry should also change name.")
    }

    func testEntryDescriptionUnwrap() {
        let entry = EntryJournal(context: managedObjectContext)

        entry.entryDescriptionCoreData = "Example entry"
        XCTAssertEqual(entry.entryDescription, "Example entry", "Changing description should also change entryDescription.")

        entry.entryDescription = "Updated entry"
        XCTAssertEqual(entry.entryDescriptionCoreData, "Updated entry", "Changing entryDescription should also change description.")
    }

    func testEntryCreationDateUnwrap() {
        let entry = EntryJournal(context: managedObjectContext)
        let testDate = Date.now

        entry.creationDate = testDate
        XCTAssertEqual(entry.entryCreationDate, testDate, "Changing creationDate should also change entryCreationDate.")
    }
    
    func testEntryTopicsUnwrap() {
        let topic = Topic(context: managedObjectContext)
        let entry = EntryJournal(context: managedObjectContext)

        XCTAssertEqual(entry.entryTopics.count, 0, "A new entry should have no topics.")
        entry.addToTopics(topic)

        XCTAssertEqual(entry.entryTopics.count, 1, "Adding 1 topic to an entry should result in entryTopics having count 1.")
    }

    func testEntryTopicsList() {
        let topic = Topic(context: managedObjectContext)
        let entry = EntryJournal(context: managedObjectContext)

        topic.name = "My Topic"
        entry.addToTopics(topic)

        XCTAssertEqual(entry.entryTopicsList, "My Topic", "Adding 1 topic to an entry should make entryTopicsList be My Topic.")
    }
    
    func testEntrySortingIsStable() {
        let entry1 = EntryJournal(context: managedObjectContext)
        entry1.entryNameCoreData = "B Entry"
        entry1.creationDate = .now

        let entry2 = EntryJournal(context: managedObjectContext)
        entry2.entryNameCoreData = "B Entry"
        entry2.creationDate = .now.addingTimeInterval(1)

        let entry3 = EntryJournal(context: managedObjectContext)
        entry3.entryNameCoreData = "A Issue"
        entry3.creationDate = .now.addingTimeInterval(100)

        let allEntries = [entry1, entry2, entry3]
        let sorted = allEntries.sorted()

        XCTAssertEqual([entry3, entry1, entry2], sorted, "Sorting entry arrays should use name then creation date.")
    }
    
    
    func testTopicIDUnwrap() {
        let topic = Topic(context: managedObjectContext)

        topic.id = UUID()
        XCTAssertEqual(topic.topicID, topic.id, "Changing id should also change topicID.")
    }

    func testTopicNameUnwrap() {
        let topic = Topic(context: managedObjectContext)

        topic.name = "Example Topic"
        XCTAssertEqual(topic.topicName, "Example Topic", "Changing name should also change topicName.")
    }
    
    func testTopicActiveIssues() {
        let topic = Topic(context: managedObjectContext)
        let entry = EntryJournal(context: managedObjectContext)

        XCTAssertEqual(topic.topicActiveEntries.count, 0, "A new topic should have 0 active entries.")

        topic.addToEntries(entry)
        XCTAssertEqual(topic.topicActiveEntries.count, 1, "A new topic with 1 new entry should have 1 active entry.")

        entry.completed = true
        XCTAssertEqual(topic.topicActiveEntries.count, 0, "A new topic with 1 completed entry should have 0 active entries.")
    }
    
    func testTopicSortingIsStable() {
        let topic1 = Topic(context: managedObjectContext)
        topic1.name = "B Topic"
        topic1.id = UUID()

        let topic2 = Topic(context: managedObjectContext)
        topic2.name = "B Topic"
        topic2.id = UUID(uuidString: "FFFFFFFF-DC22-4463-8C69-7275D037C13D")

        let topic3 = Topic(context: managedObjectContext)
        topic3.name = "A Topic"
        topic3.id = UUID()

        let allTopics = [topic1, topic2, topic3]
        let sortedTopics = allTopics.sorted()

        XCTAssertEqual([topic3, topic1, topic2], sortedTopics, "Sorting topic arrays should use name then UUID string.")
    }
    
    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }
    
    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        XCTAssertEqual(data, "Never ask a starfish for directions.", "The string must match DecodableString.json.")
    }
    
    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode("DecodableDictionary.json", as: [String: Int].self)
        XCTAssertEqual(data.count, 3, "There should be three items decoded from DecodableDictionary.json.")
        XCTAssertEqual(data["One"], 1, "The dictionary should contain the value 1 for the key One.")
    }
}

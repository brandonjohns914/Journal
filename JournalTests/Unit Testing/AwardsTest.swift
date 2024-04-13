//
//  AwardsTest.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import CoreData
import XCTest

@testable import Journal

final class AwardsTest: BaseTestCase {

    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }
    
    func testNewUserHasUnlockedNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }
    
    func testCreatingEntriesUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var entries = [EntryJournal]()

            for _ in 0..<value {
                let entry = EntryJournal(context: managedObjectContext)
                    entries.append(entry)
            }

            let matches = awards.filter { award in
                award.criterion == "entries" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) entries should unlock \(count + 1) awards.")

            for entry in entries {
                dataController.delete(entry)
            }

        }
    }
    
}

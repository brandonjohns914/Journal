//
//  PerformanceTests.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import XCTest
import CoreData
@testable import Journal

final class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() {
        // Create a significant amount of test data
        for _ in 1...100 {
            dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}

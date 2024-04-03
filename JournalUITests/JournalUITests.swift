//
//  JournalUITests.swift
//  JournalUITests
//
//  Created by Brandon Johns on 4/3/24.
//

import XCTest

final class JournalUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
      
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

  
    func testAppStartsWithNavigationBar() throws {
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")

    }

    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button launch.")
       XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button launch.")
      XCTAssertTrue(app.navigationBars.buttons["New Entry"].exists, "There should be a New Entry button launch.")
    }
    
    func testNoEntriesAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }
    
    func testCreatingAndDeletingEntries() {
        for tapCountAdding in 1...5 {
            app.buttons["New Entry"].tap()
            app.buttons["Entries"].tap()

            XCTAssertEqual(app.cells.count, tapCountAdding, "There should be \(tapCountAdding) rows in the list.")
        }
        
        for tapCountDeleting in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()

            XCTAssertEqual(app.cells.count, tapCountDeleting , "There should be \(tapCountDeleting) rows in the list.")
        }

    }
    
    func testEditingEntryNameUpdatesCorrectly() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")

        app.buttons["New Entry"].tap()

        app.textFields["Enter the entry name here"].tap()
        app.textFields["Enter the entry name here"].clear()
        app.typeText("My New Entry")
        
        app.buttons["Entries"].tap()
        XCTAssertTrue(app.buttons["My New Entry"].exists, "A My New Entry cell should now exist.")
    }

    func testEditingIssuePriorityShowsIcon() {
        app.buttons["New Entry"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()

        app.buttons["Entries"].tap()

        let identifier = "New Entry High Priority"
        XCTAssert(app.images[identifier].exists, "A high-priority entry needs an icon next to it.")
    }
    
    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            //for smaller screens
//            if app.windows.element.frame.contains(award.frame) == false {
//                app.swipeUp()
//            }
//            
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }


}


extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

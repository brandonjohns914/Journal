//
//  JournalTests.swift
//  JournalTests
//
//  Created by Brandon Johns on 4/2/24.
//

import CoreData
import XCTest

@testable import Journal

class BaseTestCase: XCTestCase {
    var dataController: DataController!
      var managedObjectContext: NSManagedObjectContext!

      override func setUpWithError() throws {
          dataController = DataController(inMemory: true)
          managedObjectContext = dataController.container.viewContext
      }
    
}

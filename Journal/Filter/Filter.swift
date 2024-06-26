//
//  Filter.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import Foundation
import MapKit


struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    
    //var location: Location?
    
    var topic: Topic?
    
    var location: LocationCoreData? 
    
    var activeEntriesCount: Int {
        topic?.topicActiveEntries.count ?? 0
    }
    
    static var all = Filter(id: UUID(), name: "All Entries", icon: "pencil.and.scribble")
    // all entries in the last 10 days
    static var recent = Filter(id: UUID(), name: "Recent Entries", icon: "clock", minModificationDate: .now.addingTimeInterval(86400 * -10))
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}

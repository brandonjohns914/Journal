//
//  DataController-Awards.swift
//  Journal
//
//  Created by Brandon Johns on 4/8/24.
//

import Foundation

extension DataController {
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "entries":
            // returns true if they added a certain number of entries
            let fetchRequest = EntryJournal.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "closed":
            // returns true if they closed a certain number of entries
            let fetchRequest = EntryJournal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "topics":
            // return true if they created a certain number of topics
            let fetchRequest = Topic.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "unlock":
            return fullVersionUnlocked

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
    
}

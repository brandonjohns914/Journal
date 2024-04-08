//
//  MissingTopicView.swift
//  Journal
//
//  Created by Brandon Johns on 3/14/24.
//

import SwiftUI

struct MissingTopicView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: EntryJournal
    var body: some View {
        //unselected Topics
        
        let otherTopics = dataController.missingTopics(from: entry)
        
        if otherTopics.isEmpty == false {
            Divider()
                ForEach(otherTopics) { topic in
                    Button(topic.topicName){
                        entry.addToTopics(topic)
                    }
                }
            }
        
        
    
    }
}

//#Preview {
//   MissingTopicView()
//}

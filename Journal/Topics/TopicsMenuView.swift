//
//  TopicsMenuView.swift
//  Journal
//
//  Created by Brandon Johns on 3/13/24.
//

import SwiftUI

struct TopicsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: Entry
    var body: some View {
        Menu {
            // selected topics
            ForEach(entry.entryTopics) { topic in
                Button {
                    entry.removeFromTopics(topic)
                } label: {
                    Label(topic.topicName, systemImage: "checkmark")
                }
            }
            
                        
            
            Section("Add Topics") {
                //Unselected topics
                MissingTopicView(entry: entry)
            }
            
                    
        } label: {
            Text(entry.entryTopicsList)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(nil, value: entry.entryTopicsList)
        }
    }
}

//#Preview {
//    TopicsMenuView()
//}

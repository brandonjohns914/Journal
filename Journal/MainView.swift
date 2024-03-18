//
//  MainView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject  var dataController: DataController
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var topics: FetchedResults<Topic>
    
    @State private var topicToRename: Topic?
    @State private var renamingTopic = false
    @State private var topicName = ""
    
    
    var topicFilters: [Filter] {
        topics.map{ topic in
            Filter(id: topic.topicID, name: topic.topicName, icon: "pencil.line", topic: topic)
        }
    }
    
    let smartFilters: [Filter] = [.all, .recent]
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter){
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Topics") {
                ForEach(topicFilters) { filter in
                    SmartFilterRow(filter: filter, rename: rename, delete: delete)
                    
                }
                .onDelete(perform: delete)
                
            }
        }
        .alert("Rename Topic", isPresented: $renamingTopic) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) {}
            TextField("New Name", text: $topicName)
        }
        .toolbar(content: MainViewToolbar.init)
        .navigationTitle("Filters")
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = topics[offset]
            dataController.delete(item)
        }
    }
    func delete(_ filter: Filter) {
        guard let topic = filter.topic else {return}
        dataController.delete(topic)
        dataController.save()
    }
    
    func rename(_ filter: Filter){
        topicToRename = filter.topic
        topicName = filter.name
        renamingTopic = true
    }
    
    func completeRename() {
        topicToRename?.name = topicName
        dataController.save()
    }
}

#Preview {
    MainView()
        .environmentObject(DataController.preview)
}

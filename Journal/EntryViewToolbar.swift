//
//  EntryViewToolbar.swift
//  Journal
//
//  Created by Brandon Johns on 3/13/24.
//

import SwiftUI

struct EntryViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: Entry
    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = entry.entryName
            } label: {
                Label("Copy Entry Name", systemImage: "doc.on.doc")
            }
            
            Button {
                entry.completed.toggle()
                dataController.save()
            } label: {
                Label(entry.completed ? "Re-open Entry" : "Close Entry", systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
            
            Divider()
            Section("Topics") {
                TopicsMenuView(entry: entry)
                
            }
            
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
}

#Preview {
    EntryViewToolbar(entry: Entry.example)
}

//
//  UserFilterRow.swift
//  Journal
//
//  Created by Brandon Johns on 4/2/24.
//

import SwiftUI

struct UserFilterRow: View {
    @EnvironmentObject var dataController: DataController
    
    var filter: Filter
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.topic?.name ?? "No Name", systemImage: filter.icon)
                .foregroundStyle(.green)
                .numberBadge(filter.activeEntriesCount)
                .contextMenu{
                    Button {
                        rename(filter)
                    } label : {
                        Label("Rename", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        delete(filter)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                }
                .accessibilityElement()
                .accessibilityLabel(filter.name)
                .accessibilityHint("\(filter.activeEntriesCount) entries")
                
            
        }
    }

}

#Preview {
    UserFilterRow(filter: .all, rename: {_ in}, delete: {_ in})
}

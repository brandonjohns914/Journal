//
//  UserFilterRow.swift
//  Journal
//
//  Created by Brandon Johns on 4/2/24.
//

import SwiftUI

struct UserFilterRow: View {
    var filter: Filter
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
                .foregroundStyle(.green)
                .badge(filter.activeEntriesCount)
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

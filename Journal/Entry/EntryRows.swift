//
//  EntryRows.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct EntryRows: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: Entry
    var body: some View {
        NavigationLink(value: entry) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .opacity(entry.priority == 2 ? 1 : 0)
                    .accessibilityIdentifier(entry.priority == 2 ? "\(entry.entryName) High Priority" : "")
                
                VStack(alignment: .leading) {
                    Text(entry.entryName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text("No Topics")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(entry.entryCreationDate.formatted(date: .abbreviated, time: .omitted))
                        .accessibilityLabel(entry.entryCreationDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                    
                    if entry.completed {
                        Text("Closed")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityHint(entry.priority == 2 ? "High priority" : "")
        .accessibilityIdentifier(entry.entryName)
    }
}

#Preview {
    EntryRows(entry: .example)
}

//
//  EntryRowWatch.swift
//  Journal
//
//  Created by Brandon Johns on 5/23/24.
//

import SwiftUI

struct EntryRowWatch: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: EntryJournal
    var body: some View {
        NavigationLink(value: entry) {
          
                VStack(alignment: .leading) {
                    Text(entry.entryName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(entry.entryCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                }
                .foregroundStyle(entry.completed ? .secondary : .primary)
            
        }
    }
}


#Preview {
    EntryRowWatch(entry: .example)
        .environmentObject(DataController(inMemory: true))
}

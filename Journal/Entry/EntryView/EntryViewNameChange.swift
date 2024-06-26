//
//  EntryViewNameChange.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import SwiftUI

struct EntryViewNameChange: View {
    @ObservedObject var entry: EntryJournal
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Entry", text: $entry.entryName, prompt: Text("Enter the entry name here"))
                        .font(.title)
                    
                    Text("**Modified:**  \(entry.entryModifcationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(entry.entryStatus)")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Priority", selection: $entry.priority) {
                    Text("Low").tag(Int16(0))
                    Text("Medium").tag(Int16(1))
                    Text("High").tag(Int16(2))
                    
                }
                
                Section("Topic") {
                    
                    TopicsMenuView(entry: entry)
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Description of the entry")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        TextField("Description", text: $entry.entryDescription, prompt: Text("Enter the entry"))
                    }
                }
                
                
            }
        }
    }
}

#Preview {
    EntryViewNameChange(entry: .example)
        .environmentObject(DataController(inMemory: true))
}

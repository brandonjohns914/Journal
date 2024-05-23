//
//  EntryView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: EntryJournal
    @State private var showingMap = true
   
    var body: some View {
        
            Form {
                Section {
                    VStack(alignment: .leading) {
                        TextField("Entry", text: $entry.entryName, prompt: Text("Enter the entry name here"))
                            .font(.title)
                            .labelsHidden()
                        
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
                }
  
                Section("Basic Infomation") {
                    VStack(alignment: .leading) {
                      
                        
                        TextField("Description", text: $entry.entryDescription, prompt: Text("Enter the entry"))
                            .labelsHidden()
                    }
                }
                Section("Reminders") {
                    EntryViewReminders(entry: entry)
                }
            }
            .formStyle(.grouped)
            .disabled(entry.isDeleted)
            .onReceive(entry.objectWillChange) { _ in
                dataController.save()
            }
            .onSubmit(dataController.save)
            .toolbar {
                EntryViewToolbar(entry: entry)
            }
        
        
    
        }
        

}

#Preview {
    EntryView(entry: .example)
        .environmentObject(DataController(inMemory: true))
}

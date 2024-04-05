//
//  EntryView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct EntryView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: Entry
    @State private var showingNotificationsError = false
    @Environment(\.openURL) var openURL
    
   
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
                    
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Description of the entry")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        
                        TextField("Description", text: $entry.entryDescription, prompt: Text("Enter the entry"))
                    }
                }
                
                Section("Reminders") {
                    Toggle("Show Reminders", isOn: $entry.reminderEnabled.animation())
                    
                    if entry.reminderEnabled {
                        DatePicker(
                        "Reminder time",
                        selection: $entry.entryReminderTime,
                        displayedComponents: .hourAndMinute
                        )
                    }
                }
            }
            .disabled(entry.isDeleted)
            .onReceive(entry.objectWillChange) { _ in
                dataController.queueSave()
            }
            .onSubmit(dataController.save)
            .toolbar {
                EntryViewToolbar(entry: entry)
            }
            .alert("Oops!", isPresented: $showingNotificationsError) {
                Button("Check Settings", action: showAppSettings)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("There was a problem setting your notification. Please check you have notifications enabled.")
            }
            .onChange(of: entry.reminderEnabled) { _,_ in
                updateReminder()
            }
            .onChange(of: entry.reminderTime) { _,_  in
                updateReminder()
            }

        }
        
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }
    
    func updateReminder() {
        dataController.removeReminders(for: entry)
        
        Task { @MainActor in
            if entry.reminderEnabled {
                let success = await dataController.addReminder(for: entry)
                
                if success == false {
                    entry.reminderEnabled = false
                    showingNotificationsError = true
                }
            }
        }
    }
}

//#Preview {
//    EntryView(entry: .example)
//}

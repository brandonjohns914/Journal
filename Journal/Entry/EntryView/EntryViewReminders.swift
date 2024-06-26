//
//  EntryViewReminders.swift
//  Journal
//
//  Created by Brandon Johns on 4/12/24.
//

import SwiftUI

struct EntryViewReminders: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingNotificationsError = false
    @Environment(\.openURL) var openURL

    @ObservedObject var entry: EntryJournal
    var body: some View {
        VStack {
            Toggle("Show Reminders", isOn: $entry.reminderEnabled.animation())
            
            if entry.reminderEnabled {
                DatePicker(
                    "Reminder time",
                    selection: $entry.entryReminderTime,
                    displayedComponents: .hourAndMinute
                )
            }
        }
        .alert("Oops!", isPresented: $showingNotificationsError) {
            #if os(macOS)
            SettingsLink {
                Text("Check Settings")
            }
            #elseif os(iOS)
            Button("Check Settings", action: showAppSettings)
            #endif
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("There was a problem setting your notification. Please check you have notifications enabled.")
        }
        .onChange(of: entry.reminderEnabled, updateReminder)
        
        .onChange(of: entry.reminderTime,  updateReminder)
    }
    
    #if os(iOS)
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
      
        openURL(settingsURL)
    }
    #endif
    
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

#Preview {
    EntryViewReminders(entry: .example)
        .environmentObject(DataController(inMemory: true))
}

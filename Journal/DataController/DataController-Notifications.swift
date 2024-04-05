//
//  DataController-Notifications.swift
//  Journal
//
//  Created by Brandon Johns on 4/5/24.
//

import Foundation
import UserNotifications

extension DataController {
    func addReminder(for entry: Entry) async -> Bool {
        do {
              let center = UNUserNotificationCenter.current()
            
            /// current notification settings current authorization
              let settings = await center.notificationSettings()

              switch settings.authorizationStatus {
              case .notDetermined:
                  let success = try await requestNotifications()

                  if success {
                      try await placeReminders(for: entry)
                  } else {
                      return false
                  }


              case .authorized:
                  try await placeReminders(for: entry)

              default:
                  return false
              }
                
            //return true because we got through authorized
              return true
          } catch {
              return false
          }
    }
    
    func removeReminders(for entry: Entry) {
        let center = UNUserNotificationCenter.current()
            let id = entry.objectID.uriRepresentation().absoluteString
            center.removePendingNotificationRequests(withIdentifiers: [id])

    }

    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])

    }
    
    private func placeReminders(for entry: Entry) async throws {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = entry.entryName
        
        // what we want to show on the screen
        if let entryDescription = entry.entryDescriptionCoreData {
            content.subtitle = entryDescription
        }
        // for final app
//        let components = Calendar.current.dateComponents([.hour, .minute], from: entry.entryReminderTime)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        // for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let id = entry.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await UNUserNotificationCenter.current().add(request)
    }
}

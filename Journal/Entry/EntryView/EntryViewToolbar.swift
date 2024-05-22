//
//  EntryViewToolbar.swift
//  Journal
//
//  Created by Brandon Johns on 3/13/24.
//

import CoreHaptics
import SwiftUI

struct EntryViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var entry: EntryJournal
    
    @State private var engine = try? CHHapticEngine()
    
    var openCloseButtonText: LocalizedStringKey {
        entry.completed ? "Re-open Entry" : "Close Entry"
    }
    
    var body: some View {
        Menu {
            Button("Copy Entry Name", systemImage: "doc.on.doc", action: copyToClipboard)
            
            Button(action: toggleCompleted) {
                Label(openCloseButtonText, systemImage: "bubble.left.and.exclamationmark.bubble.right")
            }
            
            
            Divider()
            Section("Topics") {
                TopicsMenuView(entry: entry)
                
            }
            
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
    
    func toggleCompleted() {
        entry.completed.toggle()
        dataController.save()
        
        if entry.completed {
            do {
                try engine?.start()
                
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
                
                // use that curve to control the haptic strength
                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )
                
                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )
                // create a continuous haptic event starting immediately and lasting one second
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )
                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)

            } catch {
                // playing haptics didn't work, but that's okay
            }
        }
    }
    
    func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = entry.entryName
        #else
        NSPasteboard.general.prepareForNewContents()
        NSPasteboard.general.setString(entry.entryName, forType: .string)
        #endif
    }
}

#Preview {
    EntryViewToolbar(entry: EntryJournal.example)
}


/*
 ios 17
 .sensoryFeedback(trigger: entry.completed) { oldValue, newValue in
     if newValue {
         .success
     } else {
         nil
     }
 }
 
 // UIKIT
 if entry.completed {
         UINotificationFeedbackGenerator().notificationOccurred(.success)
     }
 */

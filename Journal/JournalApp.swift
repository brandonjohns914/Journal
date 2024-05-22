//
//  JournalApp.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import CoreSpotlight
import SwiftUI

import LocalAuthentication

@main
struct JournalApp: App {
    
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            FaceIDAuthentication(dataController: dataController)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) {_, phase in
                if phase != .active {
                    dataController.save()
                }
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
            
        }
        
    }
    
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            dataController.selectedEntry = dataController.entry(with: uniqueIdentifier)
            dataController.selectedFilter = .all
        }
    }
    
    
}




//
//  JournalApp.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import CoreSpotlight
import SwiftUI

@main
struct JournalApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var dataController = DataController()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                MainView(dataController: dataController)
            } content: {
                ContentView(dataController: dataController)
            } detail: {
                DetailView()
            }
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

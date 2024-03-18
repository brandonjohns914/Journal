//
//  JournalApp.swift
//  Journal
//
//  Created by Brandon Johns on 3/6/24.
//

import SwiftUI

@main
struct JournalApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                MainView()
            } content: {
                ContentView()
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
        }
    }
}

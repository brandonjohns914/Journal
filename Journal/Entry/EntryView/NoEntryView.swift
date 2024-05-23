//
//  NoEntryView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct NoEntryView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Text("No Entry Selected")
            .font(.title)
            .foregroundStyle(.secondary)
        
        Button("New Entry", action: dataController.newEntry)
    }
}

#Preview {
    NoEntryView()
        .environmentObject(DataController(inMemory: true))
}

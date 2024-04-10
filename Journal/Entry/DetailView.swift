//
//  DetailView.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        
            VStack {
                if let entry = dataController.selectedEntry {
                    EntryView(entry: entry)
                } else {
                    NoEntryView()
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        
        
    }
}

#Preview {
    DetailView()
}

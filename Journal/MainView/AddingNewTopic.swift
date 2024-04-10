//
//  AddingNewTopic.swift
//  Journal
//
//  Created by Brandon Johns on 4/10/24.
//

import SwiftUI

struct AddingNewTopic: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingStore = false
    var body: some View {
      

        Button(action: tryNewTopic) {
            Label("Add Topic", systemImage: "plus")
        }
        .sheet(isPresented: $showingStore, content: StoreView.init)
    }
    
    func tryNewTopic() {
        if dataController.newTopic() == false {
            showingStore = true
        }
    }
}

#Preview {
    AddingNewTopic()
}

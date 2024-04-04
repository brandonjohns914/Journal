//
//  MainViewToolbar.swift
//  Journal
//
//  Created by Brandon Johns on 3/13/24.
//

import SwiftUI

struct MainViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State private  var showingAwards = false
    var body: some View {
        Button(action: dataController.newTopic) {
            Label("Add Topic", systemImage: "plus")
        }
        
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show Awards",systemImage: "rosette")
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
        
        
        #if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
        
        #endif
    }
}


//
//  AwardsView.swift
//  Journal
//
//  Created by Brandon Johns on 3/12/24.
//

import SwiftUI

struct AwardsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var awardTitle: LocalizedStringKey {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 75, height: 75)
                                .foregroundStyle(color(for: award))
                        }
                        .buttonStyle(.borderless)
                        .scaledToFit()
                        .accessibilityLabel(label(for: award))
                        .accessibilityHint(award.description)
                    }
                }
                
            }
            .macFrame(minWidth: 600, maxHeight: 500)
            .alert(awardTitle, isPresented: $showingAwardDetails) {
                
            } message: {
                Text(selectedAward.description)
            }
            .navigationTitle("Awards")
            #if !os(watchOS)
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
            #endif
        }
    }
    
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }
    
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
    }
}

#Preview {
    AwardsView()
        .environmentObject(DataController(inMemory: true))
}

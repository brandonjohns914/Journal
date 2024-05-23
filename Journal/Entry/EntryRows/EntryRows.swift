//
//  EntryRows.swift
//  Journal
//
//  Created by Brandon Johns on 3/7/24.
//

import SwiftUI

struct EntryRows: View {
    @EnvironmentObject var dataController: DataController
    @StateObject var viewModel: ViewModel
    var body: some View {
        NavigationLink(value: viewModel.entry) {
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                    .opacity(viewModel.iconOpactiy)
                    .accessibilityIdentifier(viewModel.iconIdentifier)
                
                VStack(alignment: .leading) {
                    Text(viewModel.entryName)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundStyle(.blue)
                    
                    Text(viewModel.entryTopicsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                
                        .foregroundStyle(.cyan)
                    
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(viewModel.creationDate)
                        .accessibilityLabel(viewModel.accessibilityCreationDate)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    if viewModel.completed {
                        Text("Closed")
                            .font(.body.smallCaps())
                          
                            .foregroundStyle(.yellow)
                        
                    } else {
                        Text("Open")
                            .font(.body.smallCaps())
                            .foregroundStyle(.green)
                    }
                }
                .foregroundStyle(.secondary)
            }
            
        }
        .accessibilityHint(viewModel.accessibilityHint)
        .accessibilityIdentifier(viewModel.entry.entryName)
    }
    
    init(entry: EntryJournal) {
        let viewModel = ViewModel(entry: entry)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
}

#Preview {
    EntryRows(entry: .example)
        .environmentObject(DataController(inMemory: true))
}

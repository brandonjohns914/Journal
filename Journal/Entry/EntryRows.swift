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
                    .opacity(viewModel.iconOpactiy)
                    .accessibilityIdentifier(viewModel.iconIdentifier)
                
                VStack(alignment: .leading) {
                    Text(viewModel.entryName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(viewModel.entryTopicsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(viewModel.creationDate)
                        .accessibilityLabel(viewModel.accessibilityCreationDate)
                        .font(.subheadline)
                    
                    if viewModel.completed {
                        Text("Closed")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityHint(viewModel.accessibilityHint)
        .accessibilityIdentifier(viewModel.entry.entryName)
    }
    
    init(entry: Entry) {
        let viewModel = ViewModel(entry: entry)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
}

#Preview {
    EntryRows(entry: .example)
}

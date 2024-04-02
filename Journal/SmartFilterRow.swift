//
//  SmartFilterRow.swift
//  Journal
//
//  Created by Brandon Johns on 3/13/24.
//

import SwiftUI

struct SmartFilterRow: View {
    var filter: Filter
    
    var body: some View {
        NavigationLink(value: filter) {
            // this shows all issues.names
            // localized string for different languages
            Label(LocalizedStringKey(filter.name), systemImage: filter.icon)
        }

    }
}

#Preview {
    SmartFilterRow(filter: .all)
}

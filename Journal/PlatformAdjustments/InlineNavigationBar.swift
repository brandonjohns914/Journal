//
//  InlineNavigationBar.swift
//  Journal
//
//  Created by Brandon Johns on 5/22/24.
//

import SwiftUI

extension View {
    func inlineNavigationBar() -> some View {
        #if os(macOS)
        self
        #else
        self.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

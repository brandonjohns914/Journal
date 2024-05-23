//
//  ToolbarItemPlacement.swift
//  Journal
//
//  Created by Brandon Johns on 5/23/24.
//

import SwiftUI

extension ToolbarItemPlacement {
#if os(watchOS)
    static let automaticOrLeading = ToolbarItemPlacement.topBarLeading
    static let automaticOrTrailing = ToolbarItemPlacement.topBarTrailing
#else
    static let automaticOrLeading = ToolbarItemPlacement.automatic
    static let automaticOrTrailing = ToolbarItemPlacement.automatic
#endif
}

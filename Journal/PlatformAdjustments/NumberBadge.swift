//
//  NumberBadge.swift
//  Journal
//
//  Created by Brandon Johns on 5/23/24.
//

import SwiftUI

extension View {
    func numberBadge(_ number: Int ) -> some View {
        #if os(watchOS)
        self
        #else
        self.badge(number)
        #endif 
    }
}

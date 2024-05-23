//
//  DataController-Testing.swift
//  Journal
//
//  Created by Brandon Johns on 5/23/24.
//

import SwiftUI

extension DataController {
    func checkForTestEnvironment() {
#if DEBUG
if CommandLine.arguments.contains("enable-testing") {

    self.deleteAll()
    #if os(iOS)
    UIView.setAnimationsEnabled(false)
    #endif
}
#endif
    }
}

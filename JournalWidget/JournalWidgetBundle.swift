//
//  JournalWidgetBundle.swift
//  JournalWidget
//
//  Created by Brandon Johns on 4/8/24.
//

import WidgetKit
import SwiftUI

@main
struct JournalWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimpleJournalWidget()
        ComplexJournalWidget()
    }
}

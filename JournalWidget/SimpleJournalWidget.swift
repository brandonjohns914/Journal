//
//  SimpleJournalWidget.swift
//  SimpleJournalWidget
//
//  Created by Brandon Johns on 4/8/24.
//


import WidgetKit
import SwiftUI

//must change the name of entry to JournalEntry
// entry = entriesJournal because of wigets


struct SimpleProvider: TimelineProvider {
    /// rough idea for users to know what the widget might look like
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date.now, entriesJournal: [.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entryWidget = SimpleEntry(date: Date.now, entriesJournal: loadEntryJournal())
        completion(entryWidget)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entryWidget = SimpleEntry(date: Date.now, entriesJournal: loadEntryJournal())
        let timeline = Timeline(entries: [entryWidget], policy: .never)
        completion(timeline)
    }
    
    func loadEntryJournal() -> [EntryJournal] {
        let dataController = DataController()
        let request = dataController.fetchRequestForTopEntries(count: 1)
        return dataController.results(for: request)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let entriesJournal: [EntryJournal]
}

struct SimpleJournalWidgetEntryView : View {
    var entry: SimpleProvider.Entry

    var body: some View {
        VStack {
            Text("Unresloved Entry")
                .font(.title)

            if let entryWidget = entry.entriesJournal.first {
                var journalEntryName = entryWidget.entryName
                Text(journalEntryName)
            } else {
                Text("No Entries!")
            }
        }
    }
}

struct SimpleJournalWidget: Widget {
    let kind: String = "SimpleJournalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { entry in
            if #available(iOS 17.0, *) {
                SimpleJournalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SimpleJournalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Up next…")
        .description("Your #1 top-priority entry.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SimpleJournalWidget()
} timeline: {
    SimpleEntry(date: .now, entriesJournal: [.example])
    SimpleEntry(date: .now, entriesJournal: [.example])
}

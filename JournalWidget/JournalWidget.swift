//
//  JournalWidget.swift
//  JournalWidget
//
//  Created by Brandon Johns on 4/8/24.
//


import WidgetKit
import SwiftUI

//must change the name of entry to JournalEntry
// entry = entriesJournal because of wigets


struct Provider: TimelineProvider {
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

struct JournalWidgetEntryView : View {
    var entry: Provider.Entry

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

struct JournalWidget: Widget {
    let kind: String = "JournalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                JournalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                JournalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    JournalWidget()
} timeline: {
    SimpleEntry(date: .now, entriesJournal: [.example])
    SimpleEntry(date: .now, entriesJournal: [.example])
}

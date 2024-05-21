//
//  ComplexJournalWidget.swift
//  ComplexJournalWidget
//
//  Created by Brandon Johns on 4/8/24.
//


import WidgetKit
import SwiftUI

//must change the name of entry to JournalEntry
// entry = entriesJournal because of wigets


struct ComplexProvider: TimelineProvider {
    /// rough idea for users to know what the widget might look like
    func placeholder(in context: Context) -> ComplexEntry {
        ComplexEntry(date: Date.now, entriesJournal: [.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (ComplexEntry) -> ()) {
        let entryWidget = ComplexEntry(date: Date.now, entriesJournal: loadEntryJournal())
        completion(entryWidget)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entryWidget = ComplexEntry(date: Date.now, entriesJournal: loadEntryJournal())
        let timeline = Timeline(entries: [entryWidget], policy: .never)
        completion(timeline)
    }
    
    func loadEntryJournal() -> [EntryJournal] {
        let dataController = DataController()
        let request = dataController.fetchRequestForTopEntries(count: 7)
        return dataController.results(for: request)
    }
}

struct ComplexEntry: TimelineEntry {
    let date: Date
    let entriesJournal: [EntryJournal]
}

struct ComplexJournalWidgetEntryView : View {
    var entry: ComplexProvider.Entry

    var body: some View {
        VStack(spacing: 10) {
            ForEach(entry.entriesJournal) { entryJournal in
                VStack(alignment: .leading) {
                    Text(entryJournal.entryName)
                        .font(.headline)
                    
                    if entryJournal.entryTopics.isEmpty == false {
                        Text(entryJournal.entryTopicsList)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ComplexJournalWidget: Widget {
    let kind: String = "ComplexJournalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplexProvider()) { entry in
            if #available(iOS 17.0, *) {
                ComplexJournalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ComplexJournalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Up next…")
        .description("Your most important entries.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}

#Preview(as: .systemSmall) {
    ComplexJournalWidget()
} timeline: {
    ComplexEntry(date: .now, entriesJournal: [.example])
    ComplexEntry(date: .now, entriesJournal: [.example])
}

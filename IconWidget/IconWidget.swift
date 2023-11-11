//
//  IconWidget.swift
//  IconWidget
//
//  Created by Mani on 11/11/2023.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in _: Context) -> SimpleEntry {
    SimpleEntry(date: Date())
  }

  func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date())
    completion(entry)
  }

  func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
}

struct IconWidgetEntryView: View {
  var entry: Provider.Entry

  var body: some View {
    Image("WidgetIcon")
      .resizable()
      .scaledToFit()
      .ignoresSafeArea()
  }
}

struct IconWidget: Widget {
  let kind: String = "IconWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        IconWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        IconWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabled()
    .configurationDisplayName("App Icon")
    .description("Display a large Lunar app icon.")
  }
}

#Preview(as: .systemSmall) {
  IconWidget()
} timeline: {
  SimpleEntry(date: .now)
}

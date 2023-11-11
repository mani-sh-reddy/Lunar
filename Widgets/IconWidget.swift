//
//  IconWidget.swift
//  IconWidget
//
//  Created by Mani on 11/11/2023.
//

import SwiftUI
import WidgetKit

struct IconWidgetProvider: TimelineProvider {
  func placeholder(in _: Context) -> IconWidgetEntry {
    IconWidgetEntry(date: Date())
  }

  func getSnapshot(in _: Context, completion: @escaping (IconWidgetEntry) -> Void) {
    let entry = IconWidgetEntry(date: Date())
    completion(entry)
  }

  func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [IconWidgetEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for monthOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .month, value: monthOffset, to: currentDate)!
      let entry = IconWidgetEntry(date: entryDate)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct IconWidgetEntry: TimelineEntry {
  let date: Date
}

struct IconWidgetEntryView: View {
  var entry: IconWidgetProvider.Entry

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
    StaticConfiguration(kind: kind, provider: IconWidgetProvider()) { entry in
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
  IconWidgetEntry(date: .now)
}

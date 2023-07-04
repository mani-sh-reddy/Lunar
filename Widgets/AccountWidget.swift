//
//  AccountWidget.swift
//  AccountWidget
//
//  Created by Mani on 11/11/2023.
//

import NukeUI
import SFSafeSymbols
import SwiftUI
import WidgetKit

// MARK: - DataService

// periphery:ignore
struct DataService {
  @AppStorage("activeAccountName", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountName = ""

  @AppStorage("activeAccountActorID", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountActorID = ""

  @AppStorage("activeAccountAvatarURL", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountAvatarURL = ""

  @AppStorage("activeAccountPostScore", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountPostScore = 0

  @AppStorage("activeAccountPostCount", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountPostCount = 0

  @AppStorage("activeAccountCommentScore", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountCommentScore = 0

  @AppStorage("activeAccountCommentCount", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountCommentCount = 0

  func getActiveAccount() -> (String, String, String, Int, Int, Int, Int) {
    (
      activeAccountName,
      activeAccountActorID,
      activeAccountAvatarURL,
      activeAccountPostScore,
      activeAccountPostCount,
      activeAccountCommentScore,
      activeAccountCommentCount
    )
  }
}

// MARK: - AccountWidgetProvider

struct AccountWidgetProvider: TimelineProvider {
  let data = DataService()

  func placeholder(in _: Context) -> AccountWidgetEntry {
    AccountWidgetEntry(date: Date(), account: data.getActiveAccount())
  }

  func getSnapshot(in _: Context, completion: @escaping (AccountWidgetEntry) -> Void) {
    let entry = AccountWidgetEntry(date: Date(), account: data.getActiveAccount())
    completion(entry)
  }

  func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [AccountWidgetEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = AccountWidgetEntry(date: entryDate, account: data.getActiveAccount())
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

// MARK: - AccountWidgetEntry

struct AccountWidgetEntry: TimelineEntry {
  let date: Date
  let account: (String, String, String, Int, Int, Int, Int)
}

// MARK: - AccountWidgetEntryView

// periphery:ignore
struct AccountWidgetEntryView: View {
  @Environment(\.widgetFamily) var widgetFamily

  var entry: AccountWidgetProvider.Entry

  let data = DataService()

  var filePath: String { UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar")?.string(forKey: entry.account.1.replacingOccurrences(of: "/", with: "_")) ?? ""
  }

  var imageLocalURL: URL {
    URL(fileURLWithPath: filePath)
  }

  var image: UIImage? {
    do {
      let imageData = try Data(contentsOf: imageLocalURL)
      let image = UIImage(data: imageData)
      return image
    } catch {
      return nil
    }
  }

  var body: some View {
    switch widgetFamily {
    case .systemSmall, .systemMedium:
      homescreen
    case .accessoryCircular:
      accessoryCircular
    case .accessoryRectangular:
      accessoryRectangular
    case .accessoryInline:
      accessoryInline
    default:
      homescreen
    }
  }

  var accessoryRectangular: some View {
    HStack {
      userAvatar
      VStack {
        postsMetadataLockScreen
        commentsMetadataLockScreen
      }
    }
  }

  var accessoryInline: some View {
    HStack(spacing: 1) {
      Image(systemSymbol: .arrowUpCircleFill)
        .symbolRenderingMode(.hierarchical)
      Text("\(entry.account.3)")
    }
  }

  var accessoryCircular: some View {
    HStack(spacing: 1) {
      Text(String(entry.account.3))
        .bold()
      Image(systemSymbol: .arrowUp)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.secondary)
        .font(.caption)
    }
  }

  var homescreen: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        userAvatar
        Text(entry.account.0)
          .lineLimit(2)
      }
      .padding(.bottom, 0)
      HStack {
        Text(URLParser.extractDomain(from: entry.account.1))
          .textCase(.uppercase)
          .font(.caption)
          .foregroundStyle(.secondary)
        Spacer()
      }
      .padding(.bottom, 1)
      .lineLimit(1)
      Spacer()
      postsMetadata
      commentsMetadata
      Spacer()
    }
  }

  var postsMetadataLockScreen: some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      Text(String(entry.account.3))
        .font(.body)
        .bold()
      Image(systemSymbol: .arrowUp)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.secondary)
        .font(.caption)
      Spacer()
      Image(systemSymbol: .number)
        .foregroundStyle(.secondary)
        .font(.caption)
      Text(String(entry.account.4))
        .font(.caption)
        .bold()
    }
    .lineLimit(1)
    .padding(.bottom, 1)
  }

  var postsMetadata: some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      Text(String(entry.account.3))
        .font(.title2)
        .bold()
      Image(systemSymbol: .arrowUp)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.secondary)
        .font(.caption)
      Spacer()
      Image(systemSymbol: .number)
        .foregroundStyle(.secondary)
        .font(.caption)
      Text(String(entry.account.4))
        .font(.caption)
        .bold()
    }
    .lineLimit(1)
    .padding(.bottom, 1)
  }

  var commentsMetadataLockScreen: some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      Text(String(entry.account.5))
        .font(.caption)
        .bold()

      Image(systemSymbol: .quoteBubble)
        .foregroundStyle(.secondary)
        .font(.caption)
        .imageScale(.small)
      Spacer()
      Image(systemSymbol: .number)
        .foregroundStyle(.secondary)
        .font(.caption)

      Text(String(entry.account.6))
        .font(.caption)
        .bold()
    }
    .lineLimit(1)
  }

  var commentsMetadata: some View {
    HStack(alignment: .firstTextBaseline, spacing: 2) {
      Text(String(entry.account.5))
        .font(.caption)
        .bold()

      Image(systemSymbol: .quoteBubble)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.secondary)
        .font(.caption)
        .imageScale(.small)
      Spacer()
      Image(systemSymbol: .number)
        .foregroundStyle(.secondary)
        .font(.caption)

      Text(String(entry.account.6))
        .font(.caption)
        .bold()
    }
    .lineLimit(1)
  }

  var userAvatar: some View {
    Group {
      if let image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          .frame(width: 35, height: 35)
      } else {
        Image(systemSymbol: .personCropSquareFill)
          .symbolRenderingMode(.hierarchical)
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
          .frame(width: 35, height: 35)
      }
    }
  }
}

// MARK: - AccountWidget

// periphery:ignore
struct AccountWidget: Widget {
  let kind: String = "AccountWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AccountWidgetProvider()) { entry in
      if #available(iOS 17.0, *) {
        AccountWidgetEntryView(entry: entry)
          .containerBackground(.background, for: .widget)
      } else {
        AccountWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .supportedFamilies(widgetSupportedFamilies())
    .configurationDisplayName("User")
    .description("Display the information of the currently active user.")
  }

  func widgetSupportedFamilies() -> [WidgetFamily] {
    if #available(iOS 16, *) {
      [
        .systemSmall,
        .systemMedium,
        .accessoryCircular,
        .accessoryRectangular,
        .accessoryInline,
      ]
    } else {
      [
        .systemSmall,
        .systemMedium,
      ]
    }
  }
}

// MARK: - Previews

// periphery:ignore
struct AccountWidget_Previews: PreviewProvider {
  static var previews: some View {
    let entry = AccountWidgetEntry(
      date: Date(),
      account: (
        "mani",
        "https://lemmy.world/u/mani",
        "https://lemmy.world/pictrs/image/72d8c20e-1d55-42db-8db1-aa47ff4036ef.jpeg",
        123,
        32,
        456,
        56
      )
    )
    if #available(iOS 17.0, *) {
      AccountWidgetEntryView(entry: entry)
        .containerBackground(.background, for: .widget)
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    } else {
      AccountWidgetEntryView(entry: entry)
        .padding()
        .background()
    }
  }
}

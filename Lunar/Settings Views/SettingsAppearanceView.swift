//
//  SettingsAppearanceView.swift
//  Lunar
//
//  Created by Mani on 03/12/2023.
//

import Defaults
import MarkdownUI
import SFSafeSymbols
import SwiftUI

enum PostsViewStyle: String, Defaults.Serializable {
  case large
  case compact
}

struct SettingsAppearanceView: View {
  @AppStorage("appAppearance") var appAppearance: AppearanceOptions = .system

  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString
  @Default(.commentMetadataPosition) var commentMetadataPosition
  @Default(.detailedCommunityLabels) var detailedCommunityLabels
  @Default(.postsViewStyle) var postsViewStyle
  @Default(.autoCollapseBots) var autoCollapseBots
  @Default(.fontSize) var fontSize

  @State var tempFontSize = 16.0

  var accentColorsList: [String] = [
    "blue", "indigo", "purple", "pink", "red", "orange",
    "yellow", "brown", "green", "mint", "cyan", "gray",
  ]

  var body: some View {
    List {
      Section {
        textPreview
        fontSizeSlider
      } header: { Text("Font") }

      Section {
        appearancePicker
        accentColorPicker
      } header: { Text("Style") }

      Section {
        postsPageStylePicker
        commentMetadataLayoutPicker
        /// **TBD**  autoCollapseBotsToggle
        detailedCommunityLabelsToggle
      } header: { Text("Layout") }

        .navigationTitle("Appearance")
    }
  }

  var textPreview: some View {
    Markdown { "**The fediverse** is an ensemble of social networks, which, while independently hosted, can communicate with each other. _ActivityPub_, a [W3C](https://www.w3.org) standard, is the most widely used protocol that powers the fediverse." }
      .markdownTextStyle(\.text) { FontSize(tempFontSize) }
      .markdownTheme(.gitHub)
  }

  var fontSizeSlider: some View {
//    Slider(value: $fontSize, in: minFontScale...maxFontScale, step: step)
    Slider(
      value: $tempFontSize,
      in: 10 ... 20,
      step: 1,
      minimumValueLabel: Text(String(Int(tempFontSize))),
      maximumValueLabel: Text(""),
      label: { Text("Font Size") }
    )
    .tint(accentColor)
    .onAppear {
      tempFontSize = fontSize
    }
    .onDebouncedChange(of: $tempFontSize, debounceFor: 1) { updatedValue in
      fontSize = updatedValue
    }
  }

  var postsPageStylePicker: some View {
    Picker("Posts Style", selection: $postsViewStyle) {
      Text("Large").tag(PostsViewStyle.large)
      Text("Compact").tag(PostsViewStyle.compact)
    }
    .pickerStyle(.menu)
  }

  var commentMetadataLayoutPicker: some View {
    Picker("Comment Metadata Position", selection: $commentMetadataPosition) {
      Text("Bottom").tag("Bottom")
      Text("Top").tag("Top")
      Text("None").tag("None")
    }
    .pickerStyle(.menu)
  }

  var autoCollapseBotsToggle: some View {
    Toggle(isOn: $autoCollapseBots) {
      Text("Auto-collapse Bots")
    }
    .tint(accentColor)
  }

  var detailedCommunityLabelsToggle: some View {
    Toggle(isOn: $detailedCommunityLabels) {
      Text("Detailed Community Labels")
    }
    .tint(accentColor)
  }

  var appearancePicker: some View {
    Picker("Appearance", selection: $appAppearance) {
      ForEach(AppearanceOptions.allCases, id: \.self) { option in
        Text(option.rawValue.capitalized)
      }
    }
    .pickerStyle(.menu)
    .onChange(of: appAppearance) { _ in
      AppearanceController.shared.setAppearance()
    }
  }

  var accentColorPicker: some View {
    HStack {
      Text("Accent Color")
      Spacer()
      Menu {
        Button {
          accentColor = ColorConverter().convertStringToColor("blue")
          accentColorString = "Default"
        } label: {
          Text("Default")
        }
        ForEach(accentColorsList, id: \.self) { color in
          HStack {
            Button {
              accentColor = ColorConverter().convertStringToColor(color)
              accentColorString = color.capitalized
            } label: {
              Text(color.capitalized)
            }
          }
        }

      } label: {
        Text(accentColorString)
          .foregroundStyle(accentColor)
          .tint(accentColor)
      }
    }
  }
}

#Preview {
  SettingsAppearanceView()
}

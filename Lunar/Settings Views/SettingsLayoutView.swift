//
//  SettingsLayoutView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Defaults
import SwiftUI

enum PostsViewStyle: String, Defaults.Serializable {
  case large
  case compact
}

struct SettingsLayoutView: View {
  @Default(.commentMetadataPosition) var commentMetadataPosition
  @Default(.detailedCommunityLabels) var detailedCommunityLabels
  @Default(.postsViewStyle) var postsViewStyle
  @Default(.autoCollapseBots) var autoCollapseBots
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.accentColor) var accentColor

  var body: some View {
    List {
      Section {
        quicklinksToggle
      } header: {
        Text("Quicklinks")
      }
      footer: {
        Text("With QuickLinks off, you'll only see Local and Federated links. Use the picker in the toolbar to sort posts.")
      }

      // MARK: - Posts Section

      Section {
        postsPageStylePicker

      } header: {
        Text("Posts")
      }

      // MARK: - Comments Section

      Section {
        commentMetadataLayoutPicker
        autoCollapseBotsToggle

      } header: {
        Text("Comments")
      } footer: {
        Text("Changes the position of upvotes, downvotes, username, and time posted to either above or below the comment text.")
      }

      // MARK: - Labels Section

      Section {
        detailedCommunityLabelsToggle
      } header: {
        Text("Labels")
      }
    }
    .navigationTitle("Layout")
  }

  var quicklinksToggle: some View {
    Toggle(isOn: $enableQuicklinks) {
      Text("Enable Quicklinks")
    }
    .tint(accentColor)
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
}

#Preview {
  SettingsLayoutView()
}

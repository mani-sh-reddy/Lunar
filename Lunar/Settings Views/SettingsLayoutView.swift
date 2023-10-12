//
//  SettingsLayoutView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Defaults
import SwiftUI

struct SettingsLayoutView: View {
  @Default(.commentMetadataPosition) var commentMetadataPosition
  @Default(.detailedCommunityLabels) var detailedCommunityLabels
  @Default(.postsViewStyle) var postsViewStyle

  var body: some View {
    List {
      // MARK: - Posts Section

      Section {
        Picker("Posts Style", selection: $postsViewStyle) {
          Text("Sparse").tag("insetGrouped")
          Text("Cosy").tag("plain")
          Text("Compact").tag("compactPlain")
        }
        .pickerStyle(.menu)

      } header: {
        Text("Posts")
      } footer: {
        Text("Note that the compact posts view is currently buggy. An update is coming soon.")
      }

      // MARK: - Comments Section

      Section {
        Picker("Comment Metadata Position", selection: $commentMetadataPosition) {
          Text("Bottom").tag("Bottom")
          Text("Top").tag("Top")
          Text("None").tag("None")
        }
        .pickerStyle(.menu)
      } header: {
        Text("Comments")
      } footer: {
        Text("Changes the position of upvotes, downvotes, username, and time posted to either above or below the comment text.")
      }

      // MARK: - Labels Section

      Section {
        Toggle(isOn: $detailedCommunityLabels) {
          Text("Detailed Community Labels")
        }
      } header: {
        Text("Labels")
      }
    }
    .navigationTitle("Layout")
  }
}

struct SettingsLayoutView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsLayoutView()
  }
}

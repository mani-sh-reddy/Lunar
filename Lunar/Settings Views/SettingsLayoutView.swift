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

  var body: some View {
    List {
      // MARK: - Posts Section

      Section {
        Picker("Posts Style", selection: $postsViewStyle) {
          Text("Large").tag(PostsViewStyle.large)
          Text("Compact").tag(PostsViewStyle.compact)
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

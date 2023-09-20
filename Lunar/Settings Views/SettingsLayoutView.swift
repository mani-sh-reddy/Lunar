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
  @Default(.compactViewEnabled) var compactViewEnabled

  var body: some View {
    List {
      // MARK: - Posts Section

      Section {
        Toggle(isOn: $compactViewEnabled) {
          Text("Compact Posts")
        }
      } header: {
        Text("Posts")
      } footer: {
        Text("Note that the compact posts view is still buggy, but an update for it is in the works.")
      }

      // MARK: - Labels Section

      Section {
        Toggle(isOn: $detailedCommunityLabels) {
          Text("Detailed Community Labels")
        }
      } header: {
        Text("Labels")
      }

      // MARK: - Comments Section

      Section {
        Picker("Comment Metadata Position", selection: $commentMetadataPosition) {
          Text("Bottom").tag("Bottom")
          Text("Top").tag("Top")
          Text("None").tag("None")
        }
      } header: {
        Text("Comments")
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

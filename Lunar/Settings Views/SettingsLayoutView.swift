//
//  SettingsLayoutView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

struct SettingsLayoutView: View {
  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings.commentMetadataPosition
  @AppStorage("detailedCommunityLabels") var detailedCommunityLabels = Settings.detailedCommunityLabels
  @AppStorage("compactViewEnabled") var compactViewEnabled = Settings.compactViewEnabled

  var body: some View {
    List {
      // MARK: - Posts Section

      Section {
        Toggle(isOn: $compactViewEnabled) {
          Text("Compact Posts")
        }
      } header: {
        Text("Posts")
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

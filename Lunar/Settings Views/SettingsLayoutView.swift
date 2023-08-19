//
//  SettingsLayoutView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

struct SettingsLayoutView: View {
  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings
    .commentMetadataPosition

  var body: some View {
    List {
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

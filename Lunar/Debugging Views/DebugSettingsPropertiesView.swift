//
//  DebugSettingsPropertiesView.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import Defaults
import SwiftUI

struct DebugSettingsPropertiesView: View {
  @Default(.selectedName) var selectedName
  @Default(.selectedActorID) var selectedEmail
  @Default(.selectedAvatarURL) var selectedAvatarURL
  @Default(.selectedActorID) var selectedActorID

  var body: some View {
    Section {
      VStack(alignment: .leading) {
        Text("Debug Properties").bold().textCase(.uppercase)
        VStack(alignment: .leading) {
          Text("selectedName: ").bold()
          Text("\(String(selectedName))")
        }.padding(.vertical, 3)
        VStack(alignment: .leading) {
          Text("selectedEmail: ").bold()
          Text("\(String(selectedEmail))")
        }.padding(.vertical, 3)
        VStack(alignment: .leading) {
          Text("selectedAvatarURL: ").bold()
          Text("\(String(selectedAvatarURL))")
        }.padding(.vertical, 3)
        VStack(alignment: .leading) {
          Text("selectedActorID: ").bold()
          Text("\(String(selectedActorID))")
        }.padding(.vertical, 3)
      }
    }
    .font(.caption)
//    .if(!debugModeEnabled) { _ in EmptyView() }
  }
}

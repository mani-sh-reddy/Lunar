//
//  DebugSettingsPropertiesView.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import SwiftUI

struct DebugSettingsPropertiesView: View {
  @AppStorage("selectedUserID") var selectedUserID = Settings.selectedUserID
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

  var body: some View {
    Section {
      VStack(alignment: .leading) {
        Text("Debug Properties").bold().textCase(.uppercase)
        VStack(alignment: .leading) {
          Text("selectedUserID: ").bold()
          Text("\(String(selectedUserID))")
        }.padding(.vertical, 3)
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
    .if(!debugModeEnabled) { _ in EmptyView() }
  }
}

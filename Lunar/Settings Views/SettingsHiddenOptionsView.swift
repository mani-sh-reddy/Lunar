//
//  SettingsHiddenOptionsView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct SettingsHiddenOptionsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled

  var body: some View {
    Section {
      Toggle(isOn: $debugModeEnabled) {
        Label {
          Text("Debug Mode")
        } icon: {
          Image(systemSymbol: .desktopcomputerTrianglebadgeExclamationmark)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.red)
        }
      }.toggleStyle(SwitchToggleStyle(tint: .red))
    } header: {
      Text("Developer Options")
    }
  }
}

struct SettingsHiddenOptionsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsHiddenOptionsView()
  }
}

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
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

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
      }
      .tint(accentColorString == "Default" ? .red : accentColor)
    } header: {
      Text("Developer Options")
    }
  }
}

#Preview {
  SettingsHiddenOptionsView()
}

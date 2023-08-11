//
//  SettingsServerSelectionSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsServerSelectionSectionView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive

  var body: some View {
    Section {
      Picker(selection: $instanceHostURL, label: Text("Lemmy Instance")) {
        Text("lemmy.world").tag("lemmy.world")
        Text("lemmy.ml").tag("lemmy.ml")
        Text("beehaw.org").tag("beehaw.org")
        Text("feddit.de").tag("feddit.de")
        Text("lemm.ee").tag("lemm.ee")
        Text("programming.dev").tag("programming.dev")
        Text("sopuli.xyz").tag("sopuli.xyz")
      }
      .pickerStyle(.menu)
      Toggle("Enable Kbin", isOn: $kbinActive).tint(.purple)
    }
  }
}

struct SettingsServerSelectionSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

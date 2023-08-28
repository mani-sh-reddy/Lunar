//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import Kingfisher
import SwiftUI

struct SettingsView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("displayName") var displayName = Settings.displayName
  @AppStorage("userName") var userName = Settings.userName
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  
  @State var selectedAccount: LoggedInAccount?
  
  var body: some View {
    NavigationView {
      List {
        DebugSettingsPropertiesView()
        NavigationLink {
          SettingsAccountView(selectedAccount: $selectedAccount)
        } label: {
          UserRowSettingsBannerView(selectedAccount: $selectedAccount)
        }
        Section{
          InstanceSelectorView()
          KbinSelectorView()
        }
        SettingsGeneralSectionView()
        SettingsAppearanceSectionView()
        SettingsInfoSectionView()
        SettingsDevSectionView()
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

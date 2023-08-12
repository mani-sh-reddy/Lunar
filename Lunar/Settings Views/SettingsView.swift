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
  @State var refreshView: Bool = false
  @State var settingsViewOpacity: Double = 1
  @State var refreshIconOpacity: Double = 0

  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0

  var body: some View {
    NavigationView {
      List {
        DebugSettingsPropertiesView()
        NavigationLink {
          SettingsAccountView(selectedAccount: $selectedAccount)
        } label: {
          UserRowSettingsBannerView(selectedAccount: $selectedAccount)
        }
        SettingsServerSelectionSectionView()
        SettingsGeneralSectionView()
        SettingsAppearanceSectionView()
        SettingsInfoSectionView()
        SettingsHiddenOptionsView()
        SettingsClearCacheButtonView()

        if debugModeEnabled {
          AppResetButton(refreshView: $refreshView)
        }
      }

      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
    .onChange(of: refreshView) { _ in
      settingsViewOpacity = 0
      logoScale = 1.0
      logoOpacity = 1.0
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        withAnimation(.easeIn) {
          settingsViewOpacity = 1
        }
        withAnimation(.smooth(duration: 1)) {
          logoScale = 0.8
        }
        withAnimation(Animation.easeInOut(duration: 1.0).delay(0)) {
          logoOpacity = 0
        }
      }
    }
    .opacity(settingsViewOpacity)
    .overlay(content: {
      Image("LunarLogo")
        .resizable()
        .scaledToFit()
        .padding(50)
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    })
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

//
//  SettingsAdditionalView.swift
//  Lunar
//
//  Created by Mani on 20/10/2023.
//

import Defaults
import Pulse
import PulseUI
import SFSafeSymbols
import SwiftUI

struct SettingsAdditionalView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen

  @State var clearedAlertPresented: Bool = false
  @State var settingsViewOpacity: Double = 1
  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0

  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    List {
      // MARK: - CLEAR CACHE

      Section {
        SettingsClearCacheView()
      } header: {
        Text("App Cache")
      }

      // MARK: - APP RESET

      Section {
        SettingsAppResetView(
          settingsViewOpacity: $settingsViewOpacity,
          logoScale: $logoScale,
          logoOpacity: $logoOpacity
        )
      } header: {
        Text("Reset")
      }

      // MARK: - ATTRIBUTIONS

      Section {
        AttributionsView()
      } header: {
        Text("Attributions")
      }
    }
    .opacity(settingsViewOpacity)
    .navigationTitle("Additional Settings")
    .alert(isPresented: $clearedAlertPresented) {
      Alert(title: Text("Cleared"))
    }
    .overlay {
      Image("LunarLogo")
        .resizable()
        .scaledToFit()
        .padding(50)
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    }
  }
}

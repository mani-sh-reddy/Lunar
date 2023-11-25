//
//  SettingsSplashScreenView.swift
//  Lunar
//
//  Created by Mani on 22/08/2023.
//

import Defaults
import SwiftUI
import WhatsNewKit

struct SettingsSplashScreenView: View {
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen
  @Default(.clearWhatsNewDefaults) var clearWhatsNewDefaults
  @Default(.clearInitialWhatsNewDefault) var clearInitialWhatsNewDefault
  @Default(.accentColor) var accentColor

  @State var alertPresented: Bool = false

  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    List {
      Section {
        Toggle(isOn: $showLaunchSplashScreen) {
          Text("Launch Splash Screen")
        }
        .tint(accentColor)

      } footer: {
        Text("Show the Lunar logo splash screen for a couple of seconds every time the app is launched.")
      }
      Section {
        Button {
          clearWhatsNewDefaults.toggle()
          notificationHaptics.notificationOccurred(.success)
          alertPresented = true
        } label: {
          Text("Clear All WhatsNewKit List")
        }
        Button {
          clearInitialWhatsNewDefault.toggle()
          notificationHaptics.notificationOccurred(.success)
          alertPresented = true
        } label: {
          Text("Clear WhatsNewKit Initial Launch")
        }
      }
    }
    .alert(isPresented: $alertPresented) {
      Alert(title: Text("Cleared"))
    }
    .navigationTitle("Splash Screen")
  }
}

#Preview {
  SettingsSplashScreenView()
}

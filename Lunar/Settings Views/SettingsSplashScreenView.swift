//
//  SettingsSplashScreenView.swift
//  Lunar
//
//  Created by Mani on 22/08/2023.
//

import SwiftUI
import WhatsNewKit

struct SettingsSplashScreenView: View {
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen
//  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen
  @AppStorage("clearWhatsNewDefaults") var clearWhatsNewDefaults = Settings.clearWhatsNewDefaults
  @AppStorage("clearInitialWhatsNewDefault") var clearInitialWhatsNewDefault = Settings.clearInitialWhatsNewDefault
  
  @State var alertPresented: Bool = false
  
  let notificationHaptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    List {
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
      Toggle(isOn: $showWelcomeScreen) {
        Text("Show Welcome Screen")
      }
    }
    .alert(isPresented: $alertPresented) {
      Alert(title: Text("Cleared"))
    }
    .navigationTitle("Splash Screen")
  }
}

struct SettingsSplashScreenView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsSplashScreenView()
  }
}

//
//  SettingsSplashScreenView.swift
//  Lunar
//
//  Created by Mani on 22/08/2023.
//

import SwiftUI

struct SettingsSplashScreenView: View {
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen
  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen

  var body: some View {
    List {
      Toggle(isOn: $showLaunchSplashScreen) {
        Text("Show Logo Launch Screen")
      }
      Toggle(isOn: $showWelcomeScreen) {
        Text("Show Welcome Screen")
      }
    }
    .navigationTitle("Splash Screens")
  }
}

struct SettingsSplashScreenView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsSplashScreenView()
  }
}

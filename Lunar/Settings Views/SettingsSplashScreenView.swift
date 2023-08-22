//
//  SettingsSplashScreenView.swift
//  Lunar
//
//  Created by Mani on 22/08/2023.
//

import SwiftUI

struct SettingsSplashScreenView: View {
  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen

  var body: some View {
    List {
      Toggle(isOn: $showLaunchSplashScreen) {
        Text("Show Splash Screen on Launch")
      }
    }
    .navigationTitle("Splash Screen")
  }
}

struct SettingsSplashScreenView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsSplashScreenView()
  }
}

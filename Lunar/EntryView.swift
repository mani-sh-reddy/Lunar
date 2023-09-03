//
//  EntryView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct EntryView: View {
  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen

  var body: some View {
    if showWelcomeScreen {
      WelcomeView()
    } else {
      if showLaunchSplashScreen {
        SplashScreen()
      } else {
        ContentView()
      }
    }
  }
}

//
//  LunarApp.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

@main
struct LunarApp: App {
  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen
  
  var body: some Scene {
    WindowGroup {
      if showWelcomeScreen {
        WelcomeScreenView()
      } else {
        if showLaunchSplashScreen {
          SplashScreen()
        } else {
          ContentView()
        }
      }
    }
  }
}

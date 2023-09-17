//
//  LunarApp.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

@main
struct LunarApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject var dataCacheHolder = DataCacheHolder(appBundleID: Settings.appBundleID)
  
  var body: some Scene {
    WindowGroup {
      EntryView()
        .environmentObject(dataCacheHolder)
        .task {
          AppearanceController.shared.setAppearance()
        }
    }
  }
}

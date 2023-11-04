//
//  LunarAppEntryView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Foundation
import SwiftUI

@main
struct LunarAppEntryView: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject var dataCacheHolder = DataCacheHolder(appBundleID: DefaultValues.appBundleID)
  @Environment(\.scenePhase) var phase
  @Default(.selectedTab) var selectedTab

  var body: some Scene {
    WindowGroup {
      WhatsNewIntermediateView()
        .environmentObject(dataCacheHolder)
        .task {
          AppearanceController.shared.setAppearance()
        }
    }
    .onChange(of: phase) { newPhase in
      switch newPhase {
      case .active:
        _ = "App is Active"
      case .inactive:
        _ = "App is Inactive"
      case .background:
        _ = "App in Background"
        PhaseChangeActions().homeScreenQuickActions()
      @unknown default:
        _ = "Unknown App State"
      }
    }
  }
}

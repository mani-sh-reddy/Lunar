//
//  LunarAppEntryView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Foundation
import SwiftUI
import WhatsNewKit

@main
struct LunarAppEntryView: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

//  @StateObject var dataCacheHolder = DataCacheHolder(appBundleID: DefaultValues.appBundleID)

//  @Environment(\.scenePhase) var phase
//
//  @State var whatsNewFirstLaunch: WhatsNew? = WhatsNewKitData().initial
////  @State var WhatsNew_2023_11: WhatsNew? = WhatsNewKitData().WhatsNew_2023_11
//
//  @Default(.accentColor) var accentColor
//  @Default(.selectedTab) var selectedTab
//  @Default(.clearWhatsNewDefaults) var clearWhatsNewDefaults
//  @Default(.clearInitialWhatsNewDefault) var clearInitialWhatsNewDefault
//
////  let whatsNewVersionStore = InMemoryWhatsNewVersionStore() /// ** Uncomment when testing **
//  let whatsNewVersionStore = UserDefaultsWhatsNewVersionStore()

  var body: some Scene {
    WindowGroup {
      TabContentView()
//        .accentColor(accentColor)
//        .sheet(whatsNew: $whatsNewFirstLaunch, versionStore: whatsNewVersionStore)
//        .sheet(whatsNew: $WhatsNew_2023_11, versionStore: whatsNewVersionStore)
//        .environmentObject(dataCacheHolder) 
//        .task { AppearanceController.shared.setAppearance() }
    }
//    .onChange(of: phase) { newPhase in phaseSwitch(phase: newPhase) }
//    .onChange(of: clearWhatsNewDefaults) { _ in whatsNewKitClearAll() }
//    .onChange(of: clearInitialWhatsNewDefault) { _ in whatsNewKitClearInitial() }
  }

//  func whatsNewKitClearAll() {
//    whatsNewVersionStore.removeAll()
//  }
//
//  func whatsNewKitClearInitial() {
//    whatsNewVersionStore.remove(presentedVersion: "0.0.0")
//  }
//
//  func phaseSwitch(phase: ScenePhase) {
//    switch phase {
//    case .active:
//      _ = "App is Active"
//    case .inactive:
//      _ = "App is Inactive"
//    case .background:
//      _ = "App in Background"
//      PhaseChangeActions().homeScreenQuickActions()
//    @unknown default:
//      _ = "Unknown App State"
//    }
//  }
}

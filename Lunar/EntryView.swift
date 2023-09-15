//
//  EntryView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI
import WhatsNewKit

struct EntryView: View {
  @AppStorage("showLaunchSplashScreen") var showLaunchSplashScreen = Settings.showLaunchSplashScreen
//  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen
  @AppStorage("clearWhatsNewDefaults") var clearWhatsNewDefaults = Settings.clearWhatsNewDefaults
  @AppStorage("clearInitialWhatsNewDefault") var clearInitialWhatsNewDefault = Settings.clearInitialWhatsNewDefault

   let userDefaultsWhatsNewVersionStore = UserDefaultsWhatsNewVersionStore()
  /// Uncomment for Testing
//  let userDefaultsWhatsNewVersionStore = InMemoryWhatsNewVersionStore()

  @State var whatsNewFirstLaunch: WhatsNew? = WhatsNew(
    version: "0.0.0",
    title: "Welcome to Lunar",
    features: [
      WhatsNewInitialInfo().intro,
      WhatsNewInitialInfo().keyFeatures,
      WhatsNewInitialInfo().discover,
      WhatsNewInitialInfo().auth,
      WhatsNewInitialInfo().open,
      WhatsNewInitialInfo().updates,
      WhatsNewInitialInfo().contribute
    ]
  )

  var body: some View {
    ContentView()
      .sheet(whatsNew: $whatsNewFirstLaunch, versionStore: userDefaultsWhatsNewVersionStore)
      .whatsNewSheet(
        layout: WhatsNew.Layout(
          contentPadding: .init(
            top: 10,
            leading: 10,
            bottom: 0,
            trailing: 30
          )
        )
      )
      .onChange(of: clearWhatsNewDefaults) { _ in
        userDefaultsWhatsNewVersionStore.removeAll()
      }
      .onChange(of: clearInitialWhatsNewDefault) { _ in
        userDefaultsWhatsNewVersionStore.remove(presentedVersion: "0.0.0")
      }
  }
}

struct EntryView_Previews: PreviewProvider {
  static var previews: some View {
    EntryView()
  }
}

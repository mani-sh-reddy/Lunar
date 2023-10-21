//
//  EntryView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import SwiftUI
import WhatsNewKit

struct EntryView: View {
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen
  @Default(.clearWhatsNewDefaults) var clearWhatsNewDefaults
  @Default(.clearInitialWhatsNewDefault) var clearInitialWhatsNewDefault

  let userDefaultsWhatsNewVersionStore = UserDefaultsWhatsNewVersionStore()
  /// Uncomment for Testing
//  let userDefaultsWhatsNewVersionStore = InMemoryWhatsNewVersionStore()

  @State var whatsNewFirstLaunch: WhatsNew? = WhatsNew(
    version: "0.0.0",
    title: "Welcome to Lunar",
    features: [
      WhatsNewInitialInfo().intro,
      WhatsNewInitialInfo().discover,
      WhatsNewInitialInfo().auth,
      WhatsNewInitialInfo().open,
      WhatsNewInitialInfo().updates,
      WhatsNewInitialInfo().contribute,
    ],
    primaryAction: WhatsNew.PrimaryAction(
      title: "Get Started",
      backgroundColor: .accentColor,
      foregroundColor: .white
    ),
    secondaryAction: WhatsNew.SecondaryAction(
      title: "Learn more about Lemmy",
      foregroundColor: .accentColor,
      hapticFeedback: .selection,
      action: .present {
        AboutLemmyView()
      }
    )
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

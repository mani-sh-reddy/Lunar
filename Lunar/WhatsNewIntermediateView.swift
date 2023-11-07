//
//  WhatsNewIntermediateView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import SwiftUI
import WhatsNewKit

struct WhatsNewIntermediateView: View {
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen
  @Default(.clearWhatsNewDefaults) var clearWhatsNewDefaults
  @Default(.clearInitialWhatsNewDefault) var clearInitialWhatsNewDefault
  @Default(.accentColor) var accentColor

  let userDefaultsWhatsNewVersionStore = UserDefaultsWhatsNewVersionStore()
  /// **Uncomment for Testing**
//    let userDefaultsWhatsNewVersionStore = InMemoryWhatsNewVersionStore()

  var whatsNewSheetLayout = WhatsNew.Layout(
    contentPadding: .init(
      top: 35,
      leading: 10,
      bottom: 0,
      trailing: 30
    )
  )

  @State var whatsNewFirstLaunch: WhatsNew? = WhatsNewKitData().initial

  var body: some View {
    TabContentView()
      .accentColor(accentColor)
      .sheet(whatsNew: $whatsNewFirstLaunch, versionStore: userDefaultsWhatsNewVersionStore)
      .whatsNewSheet()
      .environment(\.whatsNew, WhatsNewEnvironment(
        versionStore: userDefaultsWhatsNewVersionStore,
        defaultLayout: whatsNewSheetLayout,
        whatsNewCollection: WhatsNewKitCollection().whatsNewArray
      ))
      .onChange(of: clearWhatsNewDefaults) { _ in
        userDefaultsWhatsNewVersionStore.removeAll()
      }
      .onChange(of: clearInitialWhatsNewDefault) { _ in
        userDefaultsWhatsNewVersionStore.remove(presentedVersion: "0.0.0")
      }
  }
}

struct WhatsNewIntermediateView_Previews: PreviewProvider {
  static var previews: some View {
    WhatsNewIntermediateView()
  }
}

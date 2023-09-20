//
//  SettingsAppResetView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import Nuke
import SwiftUI
import UIKit

struct SettingsAppResetView: View {
  @Default(.appBundleID) var appBundleID
  @Default(.loggedInAccounts) var loggedInAccounts

  @State var alertPresented: Bool = false

  @Binding var settingsViewOpacity: Double
  @Binding var logoScale: CGFloat
  @Binding var logoOpacity: Double

  let haptics = UINotificationFeedbackGenerator()

  var body: some View {
    Button {
      alertPresented = true
    } label: {
      Label {
        Text("Reset App")
          .foregroundStyle(.foreground)
        Spacer()
      } icon: {
        Image(systemSymbol: .arrowTriangle2Circlepath)
          .foregroundStyle(.red)
          .symbolRenderingMode(.hierarchical)
      }
    }
    .alert("Reset", isPresented: $alertPresented) {
      Button("Reset", role: .destructive) {
        refreshAnimation()
        resetApp()
      }
    }
  }

  func refreshAnimation() {
    settingsViewOpacity = 0
    logoScale = 1.0
    logoOpacity = 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      withAnimation(.easeIn) {
        settingsViewOpacity = 1
      }
      withAnimation(.easeInOut(duration: 1)) {
        logoScale = 0.8
      }
      withAnimation(Animation.easeInOut(duration: 1.0).delay(0)) {
        logoOpacity = 0
      }
    }
  }

  private func resetApp() {
    loggedInAccounts.removeAll()

    KeychainHelper.standard.clearKeychain()
    if let bundleID = Bundle.main.bundleIdentifier {
      UserDefaults.standard.removePersistentDomain(forName: bundleID)
      UserDefaults.standard.synchronize()
    }

    do {
      let dataCache = try DataCache(name: "\(appBundleID)")
      dataCache.removeAll()
    } catch {
      print("DATA CACHE ERROR")
    }

    alertPresented = false
    haptics.notificationOccurred(.success)
  }
}

struct SettingsAppResetView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsAppResetView(
      settingsViewOpacity: .constant(1),
      logoScale: .constant(0),
      logoOpacity: .constant(0)
    )
    .previewLayout(.sizeThatFits)
  }
}

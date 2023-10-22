//
//  SettingsAdditionalView.swift
//  Lunar
//
//  Created by Mani on 20/10/2023.
//

import Defaults
import Pulse
import PulseUI
import SFSafeSymbols
import SwiftUI

struct SettingsAdditionalView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen

  @State private var showAboutLemmyPopover: Bool = false
  @State var clearedAlertPresented: Bool = false
  @State var settingsViewOpacity: Double = 1
  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0
//  @State private var attributionsExpanded: Bool = false

  let notificationHaptics = UINotificationFeedbackGenerator()
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    List {
      // MARK: - ABOUT LEMMY POPOVER

      Section {
        Button {
          haptics.impactOccurred(intensity: 0.5)
          showAboutLemmyPopover = true
        } label: {
          Label {
            Text("Lemmy Guide")
              .foregroundStyle(.foreground)
          } icon: {
            Image(systemSymbol: .bookClosedFill)
              .foregroundStyle(.green)
          }
        }
      } header: {
        Text("Docs")
      }

      // MARK: - DATA CACHE

      Section {
        SettingsClearCacheView()
      } header: {
        Text("App Cache")
      }

      // MARK: - DATA CACHE

      Section {
        SettingsClearRealmView()
      } header: {
        Text("Realm Database")
      }

      // MARK: - APP RESET

      Section {
        SettingsAppResetView(
          settingsViewOpacity: $settingsViewOpacity,
          logoScale: $logoScale,
          logoOpacity: $logoOpacity
        )
      } header: {
        Text("Reset")
      }

      // MARK: - ATTRIBUTIONS

      Section {
        DisclosureGroup {
          AttributionsView()
        } label: {
          Label {
            Text("Attributions")
          } icon: {
            Image(systemSymbol: .heartTextSquareFill)
              .symbolRenderingMode(.hierarchical)
              .foregroundStyle(.indigo)
          }
        }
        .tint(.indigo)
      }
    }
    .opacity(settingsViewOpacity)
    .navigationTitle("Additional Settings")
    .alert(isPresented: $clearedAlertPresented) {
      Alert(title: Text("Cleared"))
    }
    .overlay {
      Image("LunarLogo")
        .resizable()
        .scaledToFit()
        .padding(50)
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    }
    .popover(isPresented: $showAboutLemmyPopover) {
      AboutLemmyView()
    }
  }
}

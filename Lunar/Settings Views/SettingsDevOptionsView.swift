//
//  SettingsDevOptionsView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import LocalConsole
import Pulse
import PulseUI
import SFSafeSymbols
import SwiftUI

struct SettingsDevOptionsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.prominentInspectorButton) var prominentInspectorButton
  @Default(.showLaunchSplashScreen) var showLaunchSplashScreen
  @Default(.clearWhatsNewDefaults) var clearWhatsNewDefaults
  @Default(.clearInitialWhatsNewDefault) var clearInitialWhatsNewDefault
  @Default(.realmExperimentalViewEnabled) var realmExperimentalViewEnabled

  @State var clearedAlertPresented: Bool = false
  @State var settingsViewOpacity: Double = 1
  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0
  @State private var localConsoleButtonText: String = "Enable Local Console"

  let notificationHaptics = UINotificationFeedbackGenerator()
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    List {
      // MARK: - LOCAL CONSOLE

      Section {
        Button {
          haptics.impactOccurred(intensity: 0.7)
          LCManager.shared.isVisible.toggle()
          localConsoleButtonText = LCManager.shared.isVisible ? "Close Local Console" : "Enable Local Console"

        } label: {
          Label {
            Text(localConsoleButtonText)
              .foregroundStyle(.foreground)
          } icon: {
            Image(systemSymbol: .macwindow)
              .symbolRenderingMode(.multicolor)
          }
        }
      }

      // MARK: - DEBUG AND PULSE

      Section {
        Toggle(isOn: $debugModeEnabled) {
          Label {
            Text("Debug Mode")
          } icon: {
            Image(systemSymbol: .ladybugFill)
              .symbolRenderingMode(.multicolor)
          }
        }
        Toggle(isOn: $networkInspectorEnabled) {
          Label {
            Text("Pulse Network Inspector")
          } icon: {
            Image(systemSymbol: .infoCircleFill)
              .foregroundStyle(.purple)
              .symbolRenderingMode(.hierarchical)
          }
        }
        .animation(.smooth, value: networkInspectorEnabled)

        if networkInspectorEnabled {
          Toggle(isOn: $prominentInspectorButton) {
            Label {
              Text("Network Inspector Button")
            } icon: {
              Image(systemSymbol: .rectangleAndTextMagnifyingglass)
                .foregroundStyle(.orange)
            }
          }
          .animation(.smooth, value: prominentInspectorButton)

          if !prominentInspectorButton {
            NavigationLink {
              ConsoleView().closeButtonHidden()
            } label: {
              Label {
                Text("Network Inspector Console")
              } icon: {
                Image(systemSymbol: .textAndCommandMacwindow)
                  .foregroundStyle(.foreground)
              }
            }
          }
        }
      } header: {
        Text("Debug and Pulse Logger")
      }

      // MARK: - WHATSNEWKIT

      Section {
        Button {
          clearWhatsNewDefaults.toggle()
          notificationHaptics.notificationOccurred(.success)
          clearedAlertPresented = true
        } label: {
          Label {
            Text("Clear All WhatsNewKit List")
              .foregroundStyle(.foreground)
          } icon: {
            Image(systemSymbol: .rectangleStackFillBadgeMinus)
              .foregroundStyle(.gray)
              .symbolRenderingMode(.multicolor)
          }
        }
        Button {
          clearInitialWhatsNewDefault.toggle()
          notificationHaptics.notificationOccurred(.success)
          clearedAlertPresented = true
        } label: {
          Label {
            Text("Clear WhatsNewKit Initial Launch")
              .foregroundStyle(.foreground)
          } icon: {
            Image(systemSymbol: .rectangleFillBadgeMinus)
              .foregroundStyle(.gray)
              .symbolRenderingMode(.multicolor)
          }
        }
      } header: {
        Text("WhatsNewKit")
          .textCase(nil)
      }

      // MARK: - UNRELEASED VIEWS

      Section {
        NavigationLink {
          RealmBrowser()
        } label: {
          Label {
            Text("Traverse Realm")
          } icon: {
            Image(systemSymbol: .line3CrossedSwirlCircleFill)
              .foregroundStyle(.yellow)
              .symbolRenderingMode(.hierarchical)
          }
        }

        Toggle(isOn: $realmExperimentalViewEnabled) {
          Label {
            Text("Realm Experimental View")
          } icon: {
            Image(systemSymbol: .circleAndLineHorizontalFill)
              .foregroundStyle(.pink)
              .symbolRenderingMode(.hierarchical)
          }
        }

//        NavigationLink {
//          OfflineDownloaderView()
//        } label: {
//          Label {
//            Text("Offline Downloader")
//          } icon: {
//            Image(systemSymbol: .squareAndArrowDownFill)
//              .foregroundStyle(.cyan)
//              .brightness(-0.2)
//              .symbolRenderingMode(.hierarchical)
//          }
//        }

        NavigationLink {
          ColorTesterView()
        } label: {
          Label {
            Text("Color Tester")
          } icon: {
            Image(systemSymbol: .paintpaletteFill)
              .symbolRenderingMode(.multicolor)
          }
        }
        NavigationLink {
          UserDefaultsExplorerView()
        } label: {
          Label {
            Text("UserDefaults Explorer")
          } icon: {
            Image(systemSymbol: .locationCircleFill)
              .foregroundStyle(.orange)
          }
        }
        NavigationLink {
          PlaceholderView()
        } label: {
          Label {
            Text("Placeholder View")
          } icon: {
            Image(systemSymbol: .squareSplitDiagonal2x2Fill)
              .foregroundStyle(.gray)
          }
        }
      } header: {
        Text("Unreleased views")
      }

      // MARK: - APP BUNDLE ID

      Section {
        Text(Bundle.main.bundleIdentifier ?? "UNDEFINED")
      } header: {
        Text("App Bundle ID")
      }
    }
    .opacity(settingsViewOpacity)
    .navigationTitle("Developer Options")
  }
}

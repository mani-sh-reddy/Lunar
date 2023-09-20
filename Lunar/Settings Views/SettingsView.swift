//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import BetterSafariView
import Defaults
import SFSafeSymbols
import SwiftUI

struct SettingsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled

  @State var selectedAccount: AccountModel?
  @State private var showSafariGithub: Bool = false
  @State private var showSafariLemmy: Bool = false
  @State private var showSafariPrivacyPolicy: Bool = false

  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

  var body: some View {
    NavigationView {
      List {
        // MARK: - DEBUG PROPERTIES

        if debugModeEnabled {
          DebugSettingsPropertiesView()
        }

        // MARK: - ACCOUNT

        NavigationLink {
          SettingsAccountView(selectedAccount: $selectedAccount)
        } label: {
          UserRowSettingsBannerView(selectedAccount: $selectedAccount)
        }

        // MARK: - MANAGE INSTANCES

        Section {
          InstanceSelectorView()
          NavigationLink {
            ManageInstancesView()
          } label: {
            Text("Manage Instances")
          }
          KbinSelectorView()
        }

        // MARK: - NOTIFICATIONS

        Section {
          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Notifications")
            } icon: {
              Image(systemSymbol: .bellBadgeFill)
                .symbolRenderingMode(.multicolor)
            }
          }

          // MARK: - GESTURES

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Gestures")
            } icon: {
              Image(systemSymbol: .handDrawFill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
            }
          }

          // MARK: - SOUND AND HAPTICS

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Sounds and Haptics")
            } icon: {
              Image(systemSymbol: .speakerWave2Fill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.pink)
            }
          }

          // MARK: - COMPOSER

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Composer")
            } icon: {
              Image(systemSymbol: .textBubbleFill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
            }
          }

          // MARK: - SEARCH

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Search")
            } icon: {
              Image(systemSymbol: .textMagnifyingglass)
                .foregroundStyle(.teal)
            }
          }

          // MARK: - FEED

          NavigationLink {
            SettingsFeedView()
          } label: {
            Label {
              Text("Feed Options")
            } icon: {
              Image(systemSymbol: .sliderHorizontal3)
                .foregroundStyle(.brown)
            }
          }

          NavigationLink {
            CustomiseFeedQuicklinksView()
          } label: {
            Label {
              Text("Quicklinks")
            } icon: {
              Image(systemSymbol: .link)
                .symbolRenderingMode(.multicolor)
            }
          }

        } header: {
          Text("General")
        }

        // MARK: - APP ICON

        Section {
          NavigationLink {
            SettingsAppIconPickerView()
          } label: {
            Label {
              Text("App Icon")
            } icon: {
              Image(systemSymbol: .appDashed)
                .foregroundStyle(.purple)
            }
          }

          // MARK: - THEME

          NavigationLink {
            SettingsThemeView()
          } label: {
            Label {
              Text("Theme")
            } icon: {
              Image(systemSymbol: .paintbrush)
                .foregroundStyle(.indigo)
            }
          }

          // MARK: - LAYOUT

          NavigationLink {
            SettingsLayoutView()
          } label: {
            Label {
              Text("Layout")
            } icon: {
              Image(systemSymbol: .squareshapeControlhandlesOnSquareshapeControlhandles)
                .foregroundStyle(.mint)
            }
          }

        } header: {
          Text("Appearance")
        }
        Section {
          // MARK: - PRIVACY POLICY

          Button {
            showSafariPrivacyPolicy = true
          } label: {
            Label {
              Text("Privacy Policy")
                .foregroundStyle(.foreground)
            } icon: {
              Image(systemSymbol: .lockDocFill)
                .foregroundStyle(.green)
            }
          }
          .foregroundStyle(.foreground)
          .inAppSafari(
            isPresented: $showSafariPrivacyPolicy,
            stringURL: "https://github.com/mani-sh-reddy/Lunar/wiki/Privacy-Policy"
          )

          // MARK: - LEMMY COMMUNITY LINK

          Button {
            showSafariLemmy = true
          } label: {
            Label {
              Text("Contact")
                .foregroundStyle(.foreground)
            } icon: {
              Image(systemSymbol: .paperplaneFill)
                .foregroundStyle(.blue)
            }
          }
          .foregroundStyle(.foreground)
          .inAppSafari(
            isPresented: $showSafariLemmy,
            stringURL: "https://lemmy.world/c/lunar"
          )

          // MARK: - GITHUB LINK

          Button {
            showSafariGithub = true
          } label: {
            Label {
              Text("Github")
            } icon: {
              Image(asset: "GithubLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .clipped()
                .symbolRenderingMode(.hierarchical)
            }
          }
          .foregroundStyle(.foreground)
          .inAppSafari(
            isPresented: $showSafariGithub,
            stringURL: "https://github.com/mani-sh-reddy/Lunar"
          )
        } header: {
          Text("Info")
        }

        // MARK: - DEV OPTIONS

        Section {
          NavigationLink {
            SettingsDevOptionsView()
          } label: {
            Label {
              Text("Developer Options")
            } icon: {
              Image(systemSymbol: .wrenchAndScrewdriverFill)
                .foregroundStyle(.red)
            }
          }
        } header: {
          Text("Extras")
        } footer: {
          // MARK: - CREDITS

          HStack {
            Spacer()
            VStack(alignment: .center, spacing: 2) {
              Text("Lunar for Lemmy v\(appVersion)")
              Text(LocalizedStringKey("~ by [mani](http://mani-sh-reddy.github.io/) ~"))
            }
            Spacer()
          }.padding(.vertical, 20)
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

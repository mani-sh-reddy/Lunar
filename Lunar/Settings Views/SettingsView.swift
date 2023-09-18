//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import BetterSafariView
import SFSafeSymbols
import SwiftUI

struct SettingsView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @State var selectedAccount: AccountModel?
  @State private var showSafariGithub: Bool = false
  @State private var showSafariLemmy: Bool = false
  @State private var showSafariPrivacyPolicy: Bool = false

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
                .symbolRenderingMode(.palette)
                .foregroundStyle(.pink, .red)
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
                .symbolRenderingMode(.palette)
                .foregroundStyle(.mint, .blue)
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
                .symbolRenderingMode(.palette)
                .foregroundStyle(.orange, .yellow)
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
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .indigo)
            }
          }

          // MARK: - SEARCH

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Search")
            } icon: {
              Image(systemSymbol: .magnifyingglass)
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
              Image(systemSymbol: .listBulletRectanglePortraitFill)
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
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
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
                .foregroundStyle(.indigo)
            }
          }

          // MARK: - THEME

          NavigationLink {
            SettingsThemeView()
          } label: {
            Label {
              Text("Theme")
            } icon: {
              Image(systemSymbol: .paintpaletteFill)
                .symbolRenderingMode(.multicolor)
            }
          }

          // MARK: - LAYOUT

          NavigationLink {
            SettingsLayoutView()
          } label: {
            Label {
              Text("Layout")
            } icon: {
              Image(systemName: "square.on.square.squareshape.controlhandles")
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
                .foregroundStyle(.red)
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
                .symbolRenderingMode(.hierarchical)
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
            VStack(alignment: .center) {
              Text("~ made by mani ~")
                .padding(.bottom, 2)
              Text(LocalizedStringKey("[mani-sh-reddy.github.io](http://mani-sh-reddy.github.io/)"))
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

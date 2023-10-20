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
  @Default(.enableQuicklinks) var enableQuicklinks

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

        // MARK: - GENERAL SECTION

        Section {
          // MARK: - NOTIFICATIONS

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
            if enableQuicklinks {
              Label {
                Text("Quicklinks")
              } icon: {
                Image(systemSymbol: .link)
                  .symbolRenderingMode(.multicolor)
              }
            } else {
              Label {
                Text("Quicklinks disabled in Feed Options")
                  .italic()
                  .font(.caption)
              } icon: {
                Image(systemSymbol: .link)
                  .foregroundStyle(.gray)
              }
            }
          }.disabled(!enableQuicklinks)

        } header: {
          Text("General")
        }

        // MARK: - APPEARANCE SECTION

        Section {
          // MARK: - APP ICON

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

        // MARK: - INFO SECTION

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

          // MARK: - CONTACT

          Button {
            Mailto().mailto("lunarforlemmy@outlook.com")
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

        // MARK: - EXTRA SETTINGS

        Section {
          NavigationLink {
            SettingsAdditionalView()
          } label: {
            Label {
              Text("Additional Settings")
            } icon: {
              Image(systemSymbol: .shippingboxFill)
                .foregroundStyle(.brown)
            }
          }
          NavigationLink {
            SettingsDevOptionsView()
          } label: {
            Label {
              Text("Development")
            } icon: {
              Image(systemSymbol: .wrenchAndScrewdriverFill)
                .foregroundStyle(.red)
            }
          }
        } header: {
          Text("Extras")
        }

        // MARK: - LEMMY COMMUNITY LINK

        Button {
          showSafariLemmy = true
        } label: {
          Label {
            Text("lunar@lemmy.world")
              .colorMultiply(.primary)
            Spacer()
            Image(systemSymbol: .safari)
              .foregroundStyle(.secondary)
          } icon: {
            Image(asset: "LemmyWorldLogo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 32, height: 32)
              .clipped()
              .symbolRenderingMode(.hierarchical)
          }
        }
        .foregroundStyle(.foreground)
        .inAppSafari(
          isPresented: $showSafariLemmy,
          stringURL: "https://lemmy.world/c/lunar"
        )

        // MARK: - CREDITS

        Section {
          HStack {
            Spacer()
            VStack(alignment: .center, spacing: 2) {
              Text("Lunar v\(appVersion)")
              Text(LocalizedStringKey("~ by [mani](http://mani-sh-reddy.github.io/) ~"))
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            Spacer()
          }

          .listRowSeparator(.hidden)
          .listRowBackground(Color.clear)
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

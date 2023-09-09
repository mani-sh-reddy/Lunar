//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

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
        // MARK: - SEBUG PROPERTIES

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
              Image(systemName: "bell.badge.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.red)
            }
          }.disabled(true)

          // MARK: - GESTURES

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Gestures")
            } icon: {
              Image(systemName: "hand.draw.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.cyan)
            }
          }.disabled(true)

          // MARK: - SOUND AND HAPTICS

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Sounds and Haptics")
            } icon: {
              Image(systemName: "speaker.wave.2.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.green)
            }
          }.disabled(true)

          // MARK: - COMPOSER

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Composer")
            } icon: {
              Image(systemName: "pencil.line")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.indigo)
            }
          }.disabled(true)

          // MARK: - SEARCH

          NavigationLink {
            PlaceholderView()
          } label: {
            Label {
              Text("Search")
            } icon: {
              Image(systemName: "magnifyingglass")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.teal)
            }
          }.disabled(true)

          // MARK: - FEED

          NavigationLink {
            SettingsFeedView()
          } label: {
            Label {
              Text("Feed Options")
            } icon: {
              Image(systemName: "checklist")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.brown)
            }
          }.disabled(true)
          
          NavigationLink {
            CustomiseFeedQuicklinksView()
          } label: {
            Label {
              Text("Quicklinks")
            } icon: {
              Image(systemName: "link")
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
              Image(systemName: "app.dashed")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
            }
          }

          // MARK: - THEME

          NavigationLink {
            SettingsThemeView()
          } label: {
            Label {
              Text("Theme")
            } icon: {
              Image(systemName: "paintbrush")
                .symbolRenderingMode(.hierarchical)
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
              Image(systemName: "square.on.square.squareshape.controlhandles")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.mint)
            }
          }

          // MARK: - SPLASH SCREEN

          NavigationLink {
            SettingsSplashScreenView()
          } label: {
            Label {
              Text("Splash Screen")
            } icon: {
              Image(systemName: "moonphase.waning.gibbous")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.yellow)
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
              Image(systemName: "shield.lefthalf.filled")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.red)
            }
          }
          .foregroundStyle(.foreground)
          .fullScreenCover(
            isPresented: $showSafariPrivacyPolicy,
            content: {
              SFSafariViewWrapper(url: URL(string: "https://github.com/mani-sh-reddy/Lunar/wiki/Privacy-Policy")!).ignoresSafeArea()
            }
          )

          // MARK: - LEMMY COMMUNITY LINK

          Button {
            showSafariLemmy = true
          } label: {
            Label {
              Text("Contact")
                .foregroundStyle(.foreground)
            } icon: {
              Image(systemName: "paperplane.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
            }
          }
          .foregroundStyle(.foreground)
          .fullScreenCover(
            isPresented: $showSafariLemmy,
            content: {
              SFSafariViewWrapper(url: URL(string: "https://lemmy.world/c/lunar")!).ignoresSafeArea()
            }
          )

          // MARK: - GITHUB LINK

          Button {
            showSafariGithub = true
          } label: {
            Label {
              Text("Github")
            } icon: {
              Image(systemName: "ellipsis.curlybraces")
                .symbolRenderingMode(.hierarchical)
            }
          }
          .foregroundStyle(.foreground)
          .fullScreenCover(
            isPresented: $showSafariGithub,
            content: {
              SFSafariViewWrapper(url: URL(string: "https://github.com/mani-sh-reddy/Lunar")!)
                .ignoresSafeArea()
            }
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
              Image(systemName: "wrench.and.screwdriver.fill")
                .symbolRenderingMode(.hierarchical)
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
                .padding(.bottom, 3)
              Text(LocalizedStringKey("[mani-sh-reddy.github.io](http://mani-sh-reddy.github.io/)"))
            }
            Spacer()
          }.padding(.vertical, 40)
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

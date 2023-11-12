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
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

  @State var selectedAccount: AccountModel?
  @State private var showSafariGithub: Bool = false
  @State private var showSafariLemmy: Bool = false
  @State private var showSafariPrivacyPolicy: Bool = false

  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    NavigationView {
      List {
        debugSection
        accountSection
        manageInstancesSection
        Section {
          notificationsNavLink
          gesturesNavLink
          soundAndHapticsNavLink
        } header: { Text("System") }

        Section {
          composerNavLink
          searchNavLink
          quicklinksNavLink
        } header: { Text("General") }

        Section {
          appIconNavLink
          themeNavLink
          layoutNavLink
        } header: { Text("Appearance") }

        Section {
          privacyPolicyButton
          emailButton
          githubButton
        } header: { Text("Info") }

        Section {
          hiddenPostsNavLink
          additionalSettingsNavLink
          developmentSettingsNavLink
        } header: { Text("Extras") }

        Section {
          appCreditsAndInfo
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  @ViewBuilder
  var debugSection: some View {
    if debugModeEnabled {
      DebugSettingsPropertiesView()
    }
  }

  var accountSection: some View {
    NavigationLink {
      SettingsAccountView(selectedAccount: $selectedAccount)
    } label: {
      UserRowSettingsBannerView(selectedAccount: $selectedAccount)
    }
  }

  var manageInstancesSection: some View {
    Section {
      InstanceSelectorView()
      NavigationLink {
        ManageInstancesView()
      } label: {
        Text("Manage Instances")
      }
      KbinSelectorView()
    }
  }

  var notificationsNavLink: some View {
    NavigationLink {
      PlaceholderView()
    } label: {
      Label {
        Text("Notifications")
      } icon: {
        AllSymbols().notificationsSettings
      }
    }
  }

  var gesturesNavLink: some View {
    NavigationLink {
      PlaceholderView()
    } label: {
      Label {
        Text("Gestures")
      } icon: {
        AllSymbols().gesturesSettings
      }
    }
  }

  var soundAndHapticsNavLink: some View {
    NavigationLink {
      PlaceholderView()
    } label: {
      Label {
        Text("Sounds and Haptics")
      } icon: {
        AllSymbols().soundAndHapticsSettings
      }
    }
  }

  var composerNavLink: some View {
    NavigationLink {
      PlaceholderView()
    } label: {
      Label {
        Text("Composer")
      } icon: {
        AllSymbols().composerSettings
      }
    }
  }

  var searchNavLink: some View {
    NavigationLink {
      PlaceholderView()
    } label: {
      Label {
        Text("Search")
      } icon: {
        AllSymbols().searchSettings
      }
    }
  }

  var quicklinksNavLink: some View {
    NavigationLink {
      CustomiseFeedQuicklinksView()
    } label: {
      if enableQuicklinks {
        Label {
          Text("Quicklinks")
        } icon: {
          AllSymbols().quicklinksSettings
        }
      } else {
        Label {
          Text("Quicklinks disabled in Feed Options")
            .italic()
            .font(.caption)
        } icon: {
          AllSymbols().quicklinksSettingsDisabled
        }
      }
    }
    .disabled(!enableQuicklinks)
  }

  var appIconNavLink: some View {
    NavigationLink {
      SettingsAppIconPickerView()
    } label: {
      Label {
        Text("App Icon")
      } icon: {
        AllSymbols().appIconSettings
      }
    }
  }

  var themeNavLink: some View {
    NavigationLink {
      SettingsThemeView()
    } label: {
      Label {
        Text("Theme")
      } icon: {
        AllSymbols().themeSettings
      }
    }
  }

  var layoutNavLink: some View {
    NavigationLink {
      SettingsLayoutView()
    } label: {
      Label {
        Text("Layout")
      } icon: {
        AllSymbols().layoutSettings
      }
    }
  }

  var privacyPolicyButton: some View {
    Button {
      showSafariPrivacyPolicy = true
    } label: {
      Label {
        Text("Privacy Policy")
          .foregroundStyle(.foreground)
        Spacer()
        AllSymbols().externalLinkArrow
      } icon: {
        AllSymbols().privacyPolicySettings
      }
    }
    .foregroundStyle(.foreground)
    .inAppSafari(
      isPresented: $showSafariPrivacyPolicy,
      stringURL: "https://github.com/mani-sh-reddy/Lunar/wiki/Privacy-Policy"
    )
  }

  var emailButton: some View {
    Button {
      Mailto().mailto("lunarforlemmy@outlook.com")
    } label: {
      Label {
        Text("Contact")
          .foregroundStyle(.foreground)
        Spacer()
        AllSymbols().externalLinkArrow
      } icon: {
        AllSymbols().emailSettings
      }
    }
    .foregroundStyle(.foreground)
  }

  var githubButton: some View {
    Button {
      showSafariGithub = true
    } label: {
      Label {
        Text("Github")
        Spacer()
        AllSymbols().externalLinkArrow
      } icon: {
        AllSymbols().githubSettings
      }
    }
    .foregroundStyle(.foreground)
    .inAppSafari(
      isPresented: $showSafariGithub,
      stringURL: "https://github.com/mani-sh-reddy/Lunar"
    )
  }

  var hiddenPostsNavLink: some View {
    NavigationLink {
      HiddenPostsGuardView()
    } label: {
      Label {
        Text("Hidden Posts")
      } icon: {
        AllSymbols().hiddenPosts
      }
    }
  }

  var additionalSettingsNavLink: some View {
    NavigationLink {
      SettingsAdditionalView()
    } label: {
      Label {
        Text("Additional Settings")
      } icon: {
        AllSymbols().additionalSettings
      }
    }
  }

  var developmentSettingsNavLink: some View {
    NavigationLink {
      SettingsDevOptionsView()
    } label: {
      Label {
        Text("Development")
      } icon: {
        AllSymbols().developmentSettings
      }
    }
  }

  var appCreditsAndInfo: some View {
    HStack {
      Spacer()
      VStack(alignment: .center, spacing: 2) {
        Text("Lunar v\(appVersion)")
        Text(LocalizedStringKey("~ by [mani](https://github.com/mani-sh-reddy) ~"))
      }
      .font(.caption)
      .foregroundStyle(.secondary)
      Spacer()
    }

    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

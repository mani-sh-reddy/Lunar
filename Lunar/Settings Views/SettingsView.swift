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
        Image(systemSymbol: .bellBadgeFill)
          .symbolRenderingMode(.multicolor)
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
        Image(systemSymbol: .handDrawFill)
          .symbolRenderingMode(.hierarchical)
          .foregroundStyle(.blue)
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
        Image(systemSymbol: .speakerWave2Fill)
          .symbolRenderingMode(.hierarchical)
          .foregroundStyle(.pink)
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
        Image(systemSymbol: .textBubbleFill)
          .symbolRenderingMode(.hierarchical)
          .foregroundStyle(.gray)
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
        Image(systemSymbol: .textMagnifyingglass)
          .foregroundStyle(.teal)
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
        Image(systemSymbol: .appDashed)
          .foregroundStyle(.purple)
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
        Image(systemSymbol: .paintbrush)
          .foregroundStyle(.indigo)
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
        Image(systemSymbol: .squareshapeControlhandlesOnSquareshapeControlhandles)
          .foregroundStyle(.mint)
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
        Image(systemSymbol: .safari)
          .foregroundStyle(.secondary)
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
  }

  var emailButton: some View {
    Button {
      Mailto().mailto("lunarforlemmy@outlook.com")
    } label: {
      Label {
        Text("Contact")
          .foregroundStyle(.foreground)
        Spacer()
        Image(systemSymbol: .envelopeCircle)
          .foregroundStyle(.secondary)
      } icon: {
        Image(systemSymbol: .paperplaneFill)
          .foregroundStyle(.blue)
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
        Image(systemSymbol: .safari)
          .foregroundStyle(.secondary)
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
  }

  var additionalSettingsNavLink: some View {
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
  }

  var developmentSettingsNavLink: some View {
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

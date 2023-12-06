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
import UniformTypeIdentifiers

struct SettingsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString
  @Default(.activeAccount) var activeAccount

  @State private var showSafariGithub: Bool = false
  @State private var showSafariPrivacyPolicy: Bool = false
  @State private var matrixCopiedToClipboard: Bool = false
  @State private var presentingShareSheet: Bool = false
  @State private var rotationAngle: Double = 0.0

  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    NavigationView {
      List {
        debugSection
        accountSection
        manageInstancesSection

        Section {
          quicklinksNavLink
          appIconNavLink
          appearanceNavLink
        }

        Section {
          githubButton
          privacyPolicyButton
          shareLunarButton
        }

        Section {
          additionalSettingsNavLink
          developmentSettingsNavLink
        }

        Section {
          hiddenPostsNavLink
        }

        Section {
          emailButton
          matrixButton
        }

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
      SettingsAccountView()
    } label: {
      AccountItemView(account: activeAccount)
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
    }
  }

  /*
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
    */

  var quicklinksNavLink: some View {
    NavigationLink {
      SettingsQuicklinksView()
    } label: {
      Label {
        Text("Quicklinks")
      } icon: {
        AllSymbols().quicklinksSettings
      }
    }
  }

  var appIconNavLink: some View {
    NavigationLink {
      SettingsAppIconPickerView()
    } label: {
      Label {
        Text("App Icons")
      } icon: {
        // Till 03/01/2024
        if Date().timeIntervalSince1970 < 1704301200 {
          AllSymbols().christmasAppIconSettings
        } else {
          AllSymbols().appIconSettings
        }
      }
    }
  }

  var appearanceNavLink: some View {
    NavigationLink {
      SettingsAppearanceView()
    } label: {
      Label {
        Text("Appearance")
      } icon: {
        AllSymbols().themeSettings
      }
    }
  }

  /*
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
   */

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

  var matrixButton: some View {
    Button {
      notificationHaptics.notificationOccurred(.success)
      withAnimation {
        matrixCopiedToClipboard = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        withAnimation {
          matrixCopiedToClipboard = false
        }
      }

      UIPasteboard.general
        .setValue(
          "@mani.sh:matrix.org",
          forPasteboardType: UTType.plainText.identifier
        )
    } label: {
      Label {
        Text("@mani.sh:matrix.org")
        Spacer()
        if !matrixCopiedToClipboard {
          AllSymbols().copyToClipboardHint
        } else {
          Text("Copied")
            .bold()
            .font(.caption)
            .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
        }
      } icon: {
        AllSymbols().matrixSettings
      }
    }
    .foregroundStyle(.foreground)
  }

  var emailButton: some View {
    Button {
      Mailto().mailto("lunarforlemmy@outlook.com")
    } label: {
      Label {
        Text("Email Me")
          .foregroundStyle(.foreground)
        Spacer()
        AllSymbols().externalMailArrow
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

  var shareLunarButton: some View {
    Button {
      DispatchQueue.main.async {
        presentingShareSheet = true
      }
      let items: [Any] = ["https://testflight.apple.com/join/GEFCCQTb"]
      ShareSheet().share(items: items) {
        presentingShareSheet = false
      }
    } label: {
      Label {
        Text("Share Lunar")
          .foregroundStyle(.foreground)
        Spacer()
        if !presentingShareSheet {
          AllSymbols().externalShareArrow
        } else {
          Image(systemSymbol: .rays)
            .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
            .opacity(0.5)
            .rotationEffect(.degrees(rotationAngle))
            .task {
              withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360.0
              }
            }
        }

      } icon: {
        AllSymbols().shareLunarSettings
      }
    }
    .foregroundStyle(.foreground)
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
        Text("More Settings")
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
      Spacer()
    }
    .font(.caption)
    .foregroundStyle(.secondary)
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}

#Preview {
  List {
    SettingsView().appCreditsAndInfo
    SettingsView().appIconNavLink
  }
}

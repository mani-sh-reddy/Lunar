//
//  PhaseChangeActions.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

class PhaseChangeActions {
  @Default(.activeAccount) var activeAccount

  var accountSubtitle: String {
    if activeAccount.actorID.isEmpty {
      ""
    } else {
      "Signed in as \(activeAccount.name)"
    }
  }

  func homeScreenQuickActions() {
    var feedUserInfo: [String: NSSecureCoding] {
      ["name": "feed" as NSSecureCoding]
    }
    var inboxUserInfo: [String: NSSecureCoding] {
      ["name": "inbox" as NSSecureCoding]
    }
    var accountUserInfo: [String: NSSecureCoding] {
      ["name": "account" as NSSecureCoding]
    }
    var searchUserInfo: [String: NSSecureCoding] {
      ["name": "search" as NSSecureCoding]
    }

    UIApplication.shared.shortcutItems = [
      UIApplicationShortcutItem(
        type: "Feed",
        localizedTitle: "Feed",
        localizedSubtitle: "",
        icon: UIApplicationShortcutIcon(systemSymbol: .house),
        userInfo: feedUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Inbox",
        localizedTitle: "Inbox",
        localizedSubtitle: "",
        icon: UIApplicationShortcutIcon(systemSymbol: .tray),
        userInfo: inboxUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Account",
        localizedTitle: "Account",
        localizedSubtitle: accountSubtitle,
        icon: UIApplicationShortcutIcon(systemSymbol: .personCropCircle),
        userInfo: accountUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Search",
        localizedTitle: "Search",
        localizedSubtitle: "",
        icon: UIApplicationShortcutIcon(systemSymbol: .magnifyingglass),
        userInfo: searchUserInfo
      ),
    ]
  }
}

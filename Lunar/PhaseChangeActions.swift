//
//  PhaseChangeActions.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Foundation
import SwiftUI

class PhaseChangeActions {
  @Default(.activeAccount) var activeAccount
  @Default(.selectedInstance) var selectedInstance

  var accountSubtitle: String {
    if activeAccount.actorID.isEmpty {
      ""
    } else {
      "\(activeAccount.name)@\(URLParser.extractDomain(from: activeAccount.actorID))"
    }
  }

  var feedSubtitle: String {
    if selectedInstance.isEmpty {
      ""
    } else {
      "\(selectedInstance)"
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
        localizedSubtitle: feedSubtitle,
        icon: AllSymbols().feedQuickAction,
        userInfo: feedUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Inbox",
        localizedTitle: "Inbox",
        localizedSubtitle: "",
        icon: AllSymbols().inboxQuickAction,
        userInfo: inboxUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Account",
        localizedTitle: "Account",
        localizedSubtitle: accountSubtitle,
        icon: AllSymbols().accountQuickAction,
        userInfo: accountUserInfo
      ),
      UIApplicationShortcutItem(
        type: "Search",
        localizedTitle: "Search",
        localizedSubtitle: "",
        icon: AllSymbols().searchQuickAction,
        userInfo: searchUserInfo
      ),
    ]
  }
}

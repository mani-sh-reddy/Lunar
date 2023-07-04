//
//  WidgetLink.swift
//  Lunar
//
//  Created by Mani on 11/11/2023.
//

import Foundation
import SwiftUI
import WidgetKit

// periphery:ignore
struct WidgetLink {
  @AppStorage("activeAccountName", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountName = ""

  @AppStorage("activeAccountActorID", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountActorID = ""

  @AppStorage("activeAccountAvatarURL", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountAvatarURL = ""

  @AppStorage("activeAccountPostScore", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountPostScore = 0

  @AppStorage("activeAccountPostCount", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountPostCount = 0

  @AppStorage("activeAccountCommentScore", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountCommentScore = 0

  @AppStorage("activeAccountCommentCount", store: UserDefaults(suiteName: "group.io.github.mani-sh-reddy.Lunar"))
  var activeAccountCommentCount = 0

  func storeAccountData(account: AccountModel) {
    activeAccountName = account.name
    activeAccountActorID = account.actorID
    activeAccountAvatarURL = account.avatarURL
    activeAccountPostScore = account.postScore
    activeAccountPostCount = account.postCount
    activeAccountCommentScore = account.commentScore
    activeAccountCommentCount = account.commentCount
  }

  func reloadWidget(kind: String) {
    WidgetCenter.shared.reloadTimelines(ofKind: kind)
  }
}

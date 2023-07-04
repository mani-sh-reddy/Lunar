//
//  Defaults.swift
//  Lunar
//
//  Created by Mani on 190/08/2023.
//

import Defaults
import Foundation
import SwiftUI

/// ** @Default(.variableName) var variableName **

extension Defaults.Keys {
  // MARK: - Instance URLs

  static let appBundleID = Key<String>("appBundleID", default: DefaultValues.appBundleID)
  static let selectedInstance = Key<String>("selectedInstance", default: "lemmy.world")
  static let lemmyInstances = Key<[String]>("lemmyInstances", default: DefaultValues.lemmyInstances)

  // MARK: - Settings

  static let selectedAppIcon = Key<String>("selectedAppIcon", default: "AppIconDefault")
  static let kbinActive = Key<Bool>("kbinActive", default: false)
  static let legacyKbinActive = Key<Bool>("legacyKbinActive", default: false)
  static let forcedPostSort = Key<SortType>("forcedPostSort", default: .active)
  static let searchSortType = Key<SortType>("searchSortType", default: .topYear)
  static let showLaunchSplashScreen = Key<Bool>("showLaunchSplashScreen", default: true)
  static let detailedCommunityLabels = Key<Bool>("detailedCommunityLabels", default: true)
  static let legacyPostsViewStyle = Key<String>("legacyPostsViewStyle", default: "insetGrouped")
  static let postsViewStyle = Key<PostsViewStyle>("postsViewStyle", default: .large)
  static let prominentInspectorButton = Key<Bool>("prominentInspectorButton", default: true)
  static let clearWhatsNewDefaults = Key<Bool>("clearWhatsNewDefaults", default: false)
  static let clearInitialWhatsNewDefault = Key<Bool>("clearInitialWhatsNewDefault", default: false)
  static let realmExperimentalViewEnabled = Key<Bool>("realmExperimentalViewEnabled", default: false)
  static let autoCollapseBots = Key<Bool>("autoCollapseBots", default: true)
  static let commentSort = Key<String>("commentSort", default: "Hot")
  static let commentType = Key<String>("commentType", default: "All")
  static let communitiesSort = Key<String>("communitiesSort", default: "New")
  static let communitiesType = Key<String>("communitiesType", default: "All")
  static let commentMetadataPosition = Key<String>("commentMetadataPosition", default: "Top")
  static let enableQuicklinks = Key<Bool>("enableQuicklinks", default: true)
  static let accentColor = Key<Color>("accentColor", default: .blue)
  static let accentColorString = Key<String>("accentColorString", default: "Default")
  static let fontSize = Key<CGFloat>("fontSize", default: 16)

  // MARK: - Account

  static let loggedInAccounts = Key<[AccountModel]>("loggedInAccounts", default: [])
  static let activeAccount = Key<AccountModel>("activeAccount", default: AccountModel())

  // MARK: - Other

  static let debugModeEnabled = Key<Bool>("debugModeEnabled", default: false)
  static let realmLastReset = Key<String>("realmLastReset", default: "Never")
  static let networkInspectorEnabled = Key<Bool>("networkInspectorEnabled", default: false)
  static let legacyHiddenCommunitiesList = Key<[String]>("legacyHiddenCommunitiesList", default: [])
  static let subscribedCommunityIDs = Key<[Int]>("subscribedCommunityIDs", default: [])
  static let savedColors = Key<[customColor]>("savedColors", default: [])
  static let quicklinks = Key<[Quicklink]>("quicklinks", default: DefaultQuicklinks().getDefaultQuicklinks())
  static let lockedQuicklinks = Key<[Quicklink]>("lockedQuicklinks", default: DefaultQuicklinks().getLockedQuicklinks())
  static let privateMessagesRetrieved = Key<Bool>("privateMessagesRetrieved", default: false)
  static let postsSortWithToolbar = Key<SortType>("postsSortWithToolbar", default: .active)

  // MARK: - Kbin Specific

  static let kbinSelectedInstance = Key<String>("kbinSelectedInstance", default: "karab.in")
  static let legacyKbinSelectedInstance = Key<String>("legacyKbinSelectedInstance", default: "kbin.social")
}

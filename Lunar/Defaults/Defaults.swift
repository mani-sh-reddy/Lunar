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
  static let kbinHostURL = Key<String>("kbinHostURL", default: "kbin.social")

  // MARK: - Settings

  static let selectedAppIcon = Key<String>("selectedAppIcon", default: "AppIconLight")
  static let kbinActive = Key<Bool>("kbinActive", default: false)
  static let forcedPostSort = Key<SortType>("forcedPostSort", default: .active)
  static let searchSortType = Key<SortType>("searchSortType", default: .topYear)
  static let showLaunchSplashScreen = Key<Bool>("showLaunchSplashScreen", default: true)
  static let showWelcomeScreen = Key<Bool>("showWelcomeScreen", default: true)
  static let detailedCommunityLabels = Key<Bool>("detailedCommunityLabels", default: true)
  static let postsViewStyle = Key<String>("postsViewStyle", default: "insetGrouped")
  static let iridescenceEnabled = Key<Bool>("iridescenceEnabled", default: true)
  static let prominentInspectorButton = Key<Bool>("prominentInspectorButton", default: true)
  static let clearWhatsNewDefaults = Key<Bool>("clearWhatsNewDefaults", default: false)
  static let clearInitialWhatsNewDefault = Key<Bool>("clearInitialWhatsNewDefault", default: false)
  static let autoCollapseBots = Key<Bool>("autoCollapseBots", default: true)
  static let commentSort = Key<String>("commentSort", default: "Hot")
  static let commentType = Key<String>("commentType", default: "All")
  static let postSort = Key<String>("postSort", default: "Hot")
  static let postType = Key<String>("postType", default: "All")
  static let communitiesSort = Key<String>("communitiesSort", default: "New")
  static let communitiesType = Key<String>("communitiesType", default: "All")
  static let commentMetadataPosition = Key<String>("commentMetadataPosition", default: "Top")
  static let selectedSearchSortType = Key<String>("selectedSearchSortType", default: "Active")
  static let enableQuicklinks = Key<Bool>("enableQuicklinks", default: true)

  // MARK: - Other

  static let debugModeEnabled = Key<Bool>("debugModeEnabled", default: false)
  static let networkInspectorEnabled = Key<Bool>("networkInspectorEnabled", default: false)
  static let quicklinkColor = Key<Color>("quicklinkColor", default: .primary)
  static let lastDownloadedPage = Key<Int>("lastDownloadedPage", default: 1)

  // MARK: - User

  static let loggedInAccounts = Key<[AccountModel]>("loggedInAccounts", default: [])
  static let selectedName = Key<String>("selectedName", default: "")
  static let selectedEmail = Key<String>("selectedEmail", default: "")
  static let selectedAvatarURL = Key<String>("selectedAvatarURL", default: "")
  static let selectedActorID = Key<String>("selectedActorID", default: "")
  static let selectedUser = Key<[AccountModel]>("selectedUser", default: [])
  static let subscribedCommunityIDs = Key<[Int]>("subscribedCommunityIDs", default: [])
  static let savedColors = Key<[customColor]>("savedColors", default: [])
  static let quicklinks = Key<[Quicklink]>("quicklinks", default: DefaultQuicklinks().getDefaultQuicklinks())
  static let lockedQuicklinks = Key<[Quicklink]>("lockedQuicklinks", default: DefaultQuicklinks().getLockedQuicklinks())
}

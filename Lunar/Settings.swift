//
//  Settings.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation
import SwiftUI

/// **USAGE**
/// @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

enum Settings {
  static let appBundleID: String = "io.github.mani-sh-reddy.Lunar.app"
  static let instanceHostURL: String = "lemmy.world"
  static let kbinHostURL: String = "kbin.social"
  static let displayName: String = "Mani"
  static let userName: String = "mani"
  static let debugModeEnabled: Bool = false
  static let appIconName: String = "AppIcon"

  static let kbinActive: Bool = false

  /// requires extension to array
  /// useage: Text("loggedInUsersList: \(String(describing: loggedInUsersList))")
  static let loggedInUsersList: [String] = []
  static let loggedInEmailsList: [String] = []

  /// **USAGE**
  /// @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  /// **to get**
  /// initialise object
  /// var loggedInAccount = LoggedInAccount()
  /// loggedInAccount.actorID = "123"
  /// self.loggedInAccounts.append(loggedInAccount)
  static let loggedInAccounts: [LoggedInAccount] = []

  /// selectedUser split up to store in appstorage
  static let selectedUserID: String = ""
  static let selectedName: String = ""
  static let selectedEmail: String = ""
  static let selectedAvatarURL: String = ""
  static let selectedActorID: String = ""
  
  static let commentSort: String = "Hot"
  static let commentType: String = "All"
  static let postSort: String = "Hot"
  static let postType: String = "All"
  static let communitiesSort: String = "New"
  static let communitiesType: String = "All"
}

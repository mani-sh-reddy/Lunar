//
//  Settings.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation
import SwiftUI

/// **USAGE**
/// @AppStorage("userName") var userName = Settings.userName

enum Settings {
    static let appBundleID: String = "io.github.mani-sh-reddy.Lunar.app"
    static let instanceHostURL: String = "lemmy.ml"
    static let kbinHostURL: String = "kbin.social"
    static let displayName: String = "Mani"
    static let userName: String = "mani"
    // TODO: change after release
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
}

//
//  Settings.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation

/// **USAGE**
/// @AppStorage("userName") var userName = Settings.userName

enum Settings {
    static let appBundleID: String = "io.github.mani-sh-reddy.Lunar.app"
    static let instanceHostURL: String = "lemmy.world"
    static let displayName: String = "Mani"
    static let userName: String = "mani"
    // TODO: change after release
    static let debugModeEnabled: Bool = false
    static let appIconName: String = "AppIcon"
    static let selectedUser: String = ""

    /// requires extension to array
    /// useage: Text("loggedInUsersList: \(String(describing: loggedInUsersList))")
    static let loggedInUsersList: [String] = []
}

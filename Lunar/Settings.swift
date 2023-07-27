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
    static let instanceHostURL: String = "lemmy.world"
    static let displayName: String = "Mani"
    static let userName: String = "mani"
    static let debugModeEnabled: Bool = false
    static let appIconName: String = "AppIcon"
}

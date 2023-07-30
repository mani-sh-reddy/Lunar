//
//  DebugLoginPagePropertiesView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SwiftUI

struct DebugLoginPagePropertiesView: View {
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    var isLoading: Bool
    var requires2FA: Bool
    var showPassword: Bool
    var shakeLoginButton: Bool
    var shake2FAField: Bool
    var loggedIn: Bool
    var usernameOrEmail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Debug Properties").textCase(.uppercase)

            Group {
                Text("isLoading: \(String(isLoading))")
                    .booleanColor(bool: isLoading)
                Text("requires2FA: \(String(requires2FA))")
                    .booleanColor(bool: requires2FA)

                Text("showPassword: \(String(showPassword))")
                    .booleanColor(bool: showPassword)

                Text("shakeLoginButton: \(String(shakeLoginButton))")
                    .booleanColor(bool: shakeLoginButton)

                Text("shake2FAField: \(String(shake2FAField))")
                    .booleanColor(bool: shake2FAField)

                Text("loggedIn: \(String(loggedIn))")
                    .booleanColor(bool: loggedIn)
            }
            Group {
                Text("userAlreadyInUserList: \(String(loggedInUsersList.contains(usernameOrEmail.lowercased())))")
                    .booleanColor(bool: loggedInUsersList.contains(usernameOrEmail.lowercased()))

                Text("userAlreadyInEmailsList: \(String(loggedInEmailsList.contains(usernameOrEmail.lowercased())))")
                    .booleanColor(bool: loggedInEmailsList.contains(usernameOrEmail.lowercased()))

                Text("@AppStorage selectedUser: \(selectedUser)")
                Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                Text("@AppStorage loggedInEmailsList: \(loggedInEmailsList.rawValue)")
            }
        }
        .if(!debugModeEnabled) { _ in EmptyView() }
    }
}

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
    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    var isTryingLogin: Bool
    var loggedIn: Bool
    var showingTwoFactorField: Bool
    var showingTwoFactorWarning: Bool
    var showingLoginButtonWarning: Bool
    var usernameEmailInvalid: Bool
    var passwordInvalid: Bool
    var twoFactorInvalid: Bool
    var showingPopover: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Group {
                Text("Debug Properties").textCase(.uppercase)
            }
            Group {
                Text("isTryingLogin: \(String(isTryingLogin))")
                    .booleanColor(bool: isTryingLogin)
                Text("loggedIn: \(String(loggedIn))")
                    .booleanColor(bool: loggedIn)
                Text("showingTwoFactorField: \(String(showingTwoFactorField))")
                    .booleanColor(bool: showingTwoFactorField)
                Text("showingTwoFactorWarning: \(String(showingTwoFactorWarning))")
                    .booleanColor(bool: showingTwoFactorWarning)
                Text("toggleLoginButtonWarning: \(String(showingLoginButtonWarning))")
                    .booleanColor(bool: showingLoginButtonWarning)
                Text("USERNAME_EMAIL VALID?: \(String(!usernameEmailInvalid))")
                    .booleanColor(bool: !usernameEmailInvalid)
                Text("PASS VALID?: \(String(!passwordInvalid))")
                    .booleanColor(bool: !passwordInvalid)
                Text("TWOFACTOR VALID?: \(String(!twoFactorInvalid))")
                    .booleanColor(bool: !twoFactorInvalid)
                Text("showingPopover: \(String(showingPopover))")
                    .booleanColor(bool: showingPopover)
            }
            Group {
                Text("@AppStorage selectedActorID: \(selectedActorID)")
                Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                Text("@AppStorage loggedInEmailsList: \(loggedInEmailsList.rawValue)")
            }
        }
        .if(!debugModeEnabled) { _ in EmptyView() }
    }
}

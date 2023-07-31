//
//  LoginView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Alamofire
import SwiftUI

struct LoginView: View {
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    @Environment(\.dismiss) var dismiss

    @State private var isTryingLogin: Bool = false
    @State private var usernameEmailInput: String = ""
    @State private var password: String = ""
    @State private var twoFactor: String = ""
    @State private var loggedIn: Bool = false
    @State private var showingTwoFactorField: Bool = false
    @State private var showingTwoFactorWarning: Bool = false
    @State private var showingLoginButtonWarning: Bool = false
    @State private var usernameEmailInvalid: Bool = true
    @State private var passwordInvalid: Bool = true
    @State private var twoFactorInvalid: Bool = false

    @Binding var showingPopover: Bool

    var body: some View {
        List {
            Section {
                UsernameFieldView(
                    usernameEmailInput: $usernameEmailInput,
                    showingTwoFactorField: $showingTwoFactorField,
                    usernameEmailInvalid: $usernameEmailInvalid,
                    showingLoginButtonWarning: $showingLoginButtonWarning
                )
                PasswordFieldView(
                    password: $password,
                    showingTwoFactorField: $showingTwoFactorField,
                    passwordInvalid: $passwordInvalid,
                    showingLoginButtonWarning: $showingLoginButtonWarning
                )
            }

            if showingTwoFactorField {
                Section {
                    TwoFactorFieldView(
                        twoFactor: $twoFactor,
                        showingTwoFactorWarning: $showingTwoFactorWarning,
                        twoFactorInvalid: $twoFactorInvalid
//                        showingLoginButtonWarning: $showingLoginButtonWarning
                    )
                }
            }

            Section {
                LoginButtonView(
                    isTryingLogin: $isTryingLogin,
                    loggedInUsersList: $loggedInUsersList,
                    loggedInEmailsList: $loggedInEmailsList,
                    usernameEmailInput: $usernameEmailInput,
                    password: $password,
                    twoFactor: $twoFactor,
                    loggedIn: $loggedIn,
                    showingTwoFactorField: $showingTwoFactorField,
                    showingTwoFactorWarning: $showingTwoFactorWarning,
                    usernameEmailInvalid: $usernameEmailInvalid,
                    passwordInvalid: $passwordInvalid,
                    twoFactorInvalid: $twoFactorInvalid,
                    showingPopover: $showingPopover,
                    showingLoginButtonWarning: $showingLoginButtonWarning
                )
            }
            DebugLoginPagePropertiesView(
                isTryingLogin: isTryingLogin,
                loggedIn: loggedIn,
                showingTwoFactorField: showingTwoFactorField,
                showingTwoFactorWarning: showingTwoFactorWarning,
                showingLoginButtonWarning: showingLoginButtonWarning,
                usernameEmailInvalid: usernameEmailInvalid,
                passwordInvalid: passwordInvalid,
                twoFactorInvalid: twoFactorInvalid,
                showingPopover: showingPopover
            ).font(.caption2)

        }.listStyle(.insetGrouped)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        /// need to set showing popover to a constant value
        LoginView(showingPopover: .constant(false))
    }
}

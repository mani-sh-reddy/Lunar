//
//  DebugAccountsPropertiesView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SwiftUI

struct DebugAccountsPropertiesView: View {
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    var showingPopover: Bool
    var isPresentingConfirm: Bool
    var logoutAllUsersButtonClicked: Bool
    var logoutAllUsersButtonOpacity: Double
    var isLoadingDeleteButton: Bool
    var deleteConfirmationShown: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Spacer()
            Text("Debug Properties").textCase(.uppercase)
            Group {
                Text("showingPopover: \(String(showingPopover))")
                    .booleanColor(bool: showingPopover)
                Text("isPresentingConfirm: \(String(isPresentingConfirm))")
                    .booleanColor(bool: isPresentingConfirm)
                Text("logoutAllUsersButtonClicked: \(String(logoutAllUsersButtonClicked))")
                    .booleanColor(bool: logoutAllUsersButtonClicked)
                Text("logoutAllUsersButtonOpacity: \(String(logoutAllUsersButtonOpacity))")
                Text("isLoadingDeleteButton: \(String(isLoadingDeleteButton))")
                    .booleanColor(bool: isLoadingDeleteButton)
                Text("deleteConfirmationShown: \(String(deleteConfirmationShown))")
                    .booleanColor(bool: deleteConfirmationShown)
            }
            Group {
                Text("@AppStorage selectedUser: \(selectedUser)")
                Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                Text("@AppStorage loggedInEmailsList: \(loggedInEmailsList.rawValue)")
            }

            Group {
                ScrollView {
                    let keychainDebugString = KeychainHelper.standard.generateDebugString(service: "io.github.mani-sh-reddy.Lunar.app")
                    Text("KEYCHAIN: \(keychainDebugString)").font(.caption2)
                }
            }

            /// ** For Keychain Debugging**
            /// ```
            /// print(KeychainHelper.standard.generateDebugString(service: appBundleID).fastestEncoding.rawValue)
            /// ```
        }.if(!debugModeEnabled) { _ in
            EmptyView()
        }
    }
}

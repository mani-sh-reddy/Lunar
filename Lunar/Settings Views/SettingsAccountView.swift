//
//  SettingsAccountView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsAccountView: View {
    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    @State var showingPopover: Bool = false
    @State var isPresentingConfirm: Bool = false
    @State var logoutAllUsersButtonClicked: Bool = false
    @State var logoutAllUsersButtonOpacity: Double = 1
    @State var isLoadingDeleteButton: Bool = false
    @State var deleteConfirmationShown = false
    @State var isConvertingEmails: Bool = false
    @State var keychainDebugString: String = ""

    @Binding var selectedName: String
    @Binding var selectedEmail: String
    @Binding var selectedUserURL: String

    let haptic = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            LoggedInUsersListView(selectedName: $selectedName, selectedEmail: $selectedEmail, selectedUserURL: $selectedUserURL)

            AddNewUserButtonView(showingPopover: $showingPopover)

            LogoutAllUsersButtonView(
                showingPopover: $showingPopover,
                isPresentingConfirm: $isPresentingConfirm,
                logoutAllUsersButtonClicked: $logoutAllUsersButtonClicked,
                logoutAllUsersButtonOpacity: $logoutAllUsersButtonOpacity,
                isLoadingDeleteButton: $isLoadingDeleteButton,
                deleteConfirmationShown: $deleteConfirmationShown,
                isConvertingEmails: $isConvertingEmails,
                keychainDebugString: $keychainDebugString
            )

            DebugAccountsPropertiesView(
                showingPopover: showingPopover,
                isPresentingConfirm: isPresentingConfirm,
                logoutAllUsersButtonClicked: logoutAllUsersButtonClicked,
                logoutAllUsersButtonOpacity: logoutAllUsersButtonOpacity,
                isLoadingDeleteButton: isLoadingDeleteButton,
                deleteConfirmationShown: deleteConfirmationShown
            )
        }
        .navigationTitle("Accounts")
        .sheet(isPresented: $showingPopover) {
            LoginView(showingPopover: $showingPopover)
        }
    }
}

struct SettingsAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAccountView(selectedName: .constant("mani"), selectedEmail: .constant("mani@lemmy.notarealemail"), selectedUserURL: .constant("lemmy.world/u/mani"))
    }
}

//
//  LoggedInUsersListView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import SwiftUI

struct LoggedInUsersListView: View {
    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts

    @Binding var selectedName: String
    @Binding var selectedEmail: String
    @Binding var selectedUserURL: String

    let notificationHaptics = UINotificationFeedbackGenerator()

    var body: some View {
        ForEach(loggedInAccounts, id: \.actorID) { account in
            Button(action: {
                /// Also setting selected actor ID when logging in
                selectedName = account.name
                selectedEmail = account.email
                selectedUserURL = account.actorID

                selectedActorID = account.actorID
                notificationHaptics.notificationOccurred(.success)
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name).font(.title).bold()
                        Text(account.email).font(.headline)
                        Text(account.actorID).font(.caption).foregroundStyle(.secondary)
                    }
                    if selectedActorID == account.actorID {
                        Spacer()
                        Image(systemName: "circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.purple)
                    }
                }
            })
        }
    }
}

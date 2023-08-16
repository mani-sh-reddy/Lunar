//
//  LoggedInUsersListView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import SwiftUI

struct LoggedInUsersListView: View {
  @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
  @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts

  @Binding var selectedAccount: LoggedInAccount?

  var body: some View {
    ForEach(loggedInAccounts, id: \.self) { account in
      AccountSelectionItem(
        selectedAccount: $selectedAccount,
        account: account
      )
    }
  }
}

struct AccountSelectionItem: View {
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

  @Binding var selectedAccount: LoggedInAccount?

  let account: LoggedInAccount

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 3) {
        Text(account.name).font(.title2).bold()
        Text("@\(URLParser.extractDomain(from: account.actorID))")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      Spacer()
      let _ = print("\(account.actorID) == \(selectedActorID) : \(account.actorID == selectedActorID)")
      Image(systemName: account.actorID == selectedActorID ? "checkmark.circle.fill" : "circle")
        .font(.title2)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.indigo)
    }
    .contentShape(Rectangle())

    .onTapGesture {
      haptics.impactOccurred()
      selectedAccount = account
      selectedName = account.name
      selectedEmail = account.email
      selectedAvatarURL = account.avatarURL
      selectedActorID = account.actorID

      print("\(String(describing: selectedAccount?.name)) = \(account.name)")
    }
  }
}

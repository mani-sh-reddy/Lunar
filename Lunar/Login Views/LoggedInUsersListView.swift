//
//  LoggedInUsersListView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import SwiftUI

struct LoggedInUsersListView: View {
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL

  @Binding var selectedAccount: AccountModel?

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
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedUser") var selectedUser = Settings.selectedUser

  @Binding var selectedAccount: AccountModel?

  let account: AccountModel

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
      let _ = print(
        "\(account.actorID) == \(selectedActorID) : \(account.actorID == selectedActorID)")
      Image(systemSymbol: account.actorID == selectedActorID ? .checkmarkCircleFill : .circle)
        .font(.title2)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.indigo)
    }
    .contentShape(Rectangle())

    .onTapGesture {
      haptics.impactOccurred()
      selectedAccount = account
      selectedActorID = account.actorID
      selectedName = account.name
      selectedEmail = account.email
      selectedAvatarURL = account.avatarURL
      selectedUser = [account]
      /// select the correct
      print("\(String(describing: selectedAccount?.name)) = \(account.name)")
    }
  }
}

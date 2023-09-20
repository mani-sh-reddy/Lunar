//
//  AccountSelectionItem.swift
//  Lunar
//
//  Created by Mani on 20/09/2023.
//

import Defaults
import Foundation
import SwiftUI

struct AccountSelectionItem: View {
  @Default(.selectedName) var selectedName
  @Default(.selectedActorID) var selectedEmail
  @Default(.selectedAvatarURL) var selectedAvatarURL
  @Default(.selectedActorID) var selectedActorID
  @Default(.selectedUser) var selectedUser

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

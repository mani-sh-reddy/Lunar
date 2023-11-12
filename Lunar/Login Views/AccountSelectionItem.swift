//
//  AccountSelectionItem.swift
//  Lunar
//
//  Created by Mani on 20/09/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct AccountSelectionItem: View {
  @Default(.activeAccount) var activeAccount

  let account: AccountModel

  let widgetLink = WidgetLink()

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
      Image(systemSymbol: account.actorID == activeAccount.actorID ? .checkmarkCircleFill : .circle)
        .font(.title2)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(.indigo)
    }
    .contentShape(Rectangle())

    .onTapGesture {
      haptics.impactOccurred()
      activeAccount = account
      widgetLink.storeAccountData(account: activeAccount)
      widgetLink.reloadWidget(kind: "AccountWidget")
    }
  }
}

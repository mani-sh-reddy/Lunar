//
//  LoggedInUsersListView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Defaults
import NukeUI
import SwiftUI

struct LoggedInUsersListView: View {
  @Default(.loggedInAccounts) var loggedInAccounts
  @Default(.activeAccount) var activeAccount

  let widgetLink = WidgetLink()

  var body: some View {
    Picker("Accounts", selection: $activeAccount) {
      ForEach(loggedInAccounts, id: \.self) { account in
        AccountItemView(account: account)
      }
    }
    .labelsHidden()
    .pickerStyle(.inline)
    .onChange(of: activeAccount) { newValue in
      widgetLink.storeAccountData(account: newValue)
      widgetLink.reloadWidget(kind: "AccountWidget")
    }
  }
}

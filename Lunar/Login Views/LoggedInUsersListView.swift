//
//  LoggedInUsersListView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Defaults
import SwiftUI

struct LoggedInUsersListView: View {
  @Default(.loggedInAccounts) var loggedInAccounts
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.appBundleID) var appBundleID

  @Binding var selectedAccount: AccountModel?

  var body: some View {
    ForEach(loggedInAccounts, id: \.self) { account in
      AccountSelectionItem(account: account)
    }
  }
}

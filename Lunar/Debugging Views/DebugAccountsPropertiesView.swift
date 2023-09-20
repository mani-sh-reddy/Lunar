//
//  DebugAccountsPropertiesView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Defaults
import Foundation
import SwiftUI

struct DebugAccountsPropertiesView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.selectedActorID) var selectedActorID
  @Default(.loggedInAccounts) var loggedInAccounts
  @Default(.appBundleID) var appBundleID

  var showingPopover: Bool
  var isPresentingConfirm: Bool
  var logoutAllUsersButtonClicked: Bool
  var logoutAllUsersButtonOpacity: Double
  var isLoadingDeleteButton: Bool
  var deleteConfirmationShown: Bool

  var keychainDebugString: String {
    KeychainHelper.standard.generateDebugString(
      service: appBundleID
    )
  }

  var body: some View {
    Section {
      VStack(alignment: .leading, spacing: 5) {
        Text("Debug Properties").bold().textCase(.uppercase)
        Group {
          HStack {
            Text("showingPopover").bold()
            Text("\(String(showingPopover))")
              .booleanColor(bool: showingPopover)
          }
          HStack {
            Text("isPresentingConfirm").bold()
            Text("\(String(isPresentingConfirm))")
              .booleanColor(bool: isPresentingConfirm)
          }
          HStack {
            Text("logoutAllUsersButtonClicked").bold()
            Text("\(String(logoutAllUsersButtonClicked))")
              .booleanColor(bool: logoutAllUsersButtonClicked)
          }
          HStack {
            Text("logoutAllUsersButtonClicked").bold()
            Text("\(String(logoutAllUsersButtonClicked))")
              .booleanColor(bool: logoutAllUsersButtonClicked)
          }
          HStack {
            Text("logoutAllUsersButtonOpacity").bold()
            Text("\(String(logoutAllUsersButtonOpacity))")
          }
          HStack {
            Text("isLoadingDeleteButton").bold()
            Text("\(String(isLoadingDeleteButton))")
              .booleanColor(bool: isLoadingDeleteButton)
          }
          HStack {
            Text("deleteConfirmationShown").bold()
            Text("\(String(deleteConfirmationShown))")
              .booleanColor(bool: deleteConfirmationShown)
          }
        }
        VStack(alignment: .leading) {
          VStack(alignment: .leading) {
            Text("@AppStorage selectedActorID:").bold()
            Text("\(selectedActorID)")
          }.padding(.vertical, 10)
          VStack(alignment: .leading) {
            Text("@AppStorage loggedInUsersList:").bold()
            Text("**removed variable**")
          }.padding(.vertical, 10)
          VStack(alignment: .leading) {
            Text("@AppStorage loggedInEmailsList:").bold()
            Text("**removed variable**")
          }.padding(.vertical, 10)
          VStack(alignment: .leading) {
            Text("@AppStorage loggedInAccounts:").bold()
            Text("\(loggedInAccounts.rawValue)")
          }.padding(.vertical, 10)
        }
        VStack(alignment: .leading) {
          Text("KEYCHAIN").bold()
          Text("\(keychainDebugString)")
        }.padding(.vertical, 10)
      }
    }
    .font(.caption)
    .if(!debugModeEnabled) { _ in EmptyView() }
  }
}

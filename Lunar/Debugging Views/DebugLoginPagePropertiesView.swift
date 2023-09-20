//
//  DebugLoginPagePropertiesView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Defaults
import Foundation
import SwiftUI

struct DebugLoginPagePropertiesView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.selectedActorID) var selectedActorID
  @Default(.loggedInAccounts) var loggedInAccounts

  var isTryingLogin: Bool
  var loggedIn: Bool
  var showingTwoFactorField: Bool
  var showingTwoFactorWarning: Bool
  var showingLoginButtonWarning: Bool
  var usernameEmailInvalid: Bool
  var passwordInvalid: Bool
  var twoFactorInvalid: Bool
  var showingPopover: Bool

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
            Text("isTryingLogin").bold()
            Text("\(String(isTryingLogin))")
              .booleanColor(bool: isTryingLogin)
          }
          HStack {
            Text("loggedIn").bold()
            Text("\(String(loggedIn))")
              .booleanColor(bool: loggedIn)
          }
          HStack {
            Text("showingTwoFactorField").bold()
            Text("\(String(showingTwoFactorField))")
              .booleanColor(bool: showingTwoFactorField)
          }
          HStack {
            Text("showingTwoFactorWarning").bold()
            Text("\(String(showingTwoFactorWarning))")
              .booleanColor(bool: showingTwoFactorWarning)
          }
          HStack {
            Text("showingLoginButtonWarning").bold()
            Text("\(String(showingLoginButtonWarning))")
              .booleanColor(bool: showingLoginButtonWarning)
          }
          HStack {
            Text("usernameEmailInvalid").bold()
            Text("\(String(usernameEmailInvalid))")
              .booleanColor(bool: usernameEmailInvalid)
          }
          HStack {
            Text("passwordInvalid").bold()
            Text("\(String(passwordInvalid))")
              .booleanColor(bool: passwordInvalid)
          }
          HStack {
            Text("twoFactorInvalid").bold()
            Text("\(String(twoFactorInvalid))")
              .booleanColor(bool: twoFactorInvalid)
          }
          HStack {
            Text("showingPopover").bold()
            Text("\(String(showingPopover))")
              .booleanColor(bool: showingPopover)
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
      }
    }
    .font(.caption)
    .if(!debugModeEnabled) { _ in EmptyView() }
  }
}

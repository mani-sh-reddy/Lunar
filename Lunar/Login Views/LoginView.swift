//
//  LoginView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Alamofire
import SwiftUI

enum FocusedField {
  case username
  case password
}

struct LoginView: View {
  @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
  @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList

  @State private var isTryingLogin: Bool = false
  @State private var usernameEmailInput: String = ""
  @State private var password: String = ""
  @State private var twoFactor: String = ""
  @State private var loggedIn: Bool = false
  @State private var showingTwoFactorField: Bool = false
  @State private var showingTwoFactorWarning: Bool = false
  @State private var showingLoginButtonWarning: Bool = false
  @State private var usernameEmailInvalid: Bool = true
  @State private var passwordInvalid: Bool = true
  @State private var twoFactorInvalid: Bool = false

  @Binding var showingPopover: Bool
  @Binding var isLoginFlowComplete: Bool

  @FocusState private var focusedField: FocusedField?

  var body: some View {
    List {
      InstanceSelectorView()
      Section {
        UsernameFieldView(
          usernameEmailInput: $usernameEmailInput,
          showingTwoFactorField: $showingTwoFactorField,
          usernameEmailInvalid: $usernameEmailInvalid,
          showingLoginButtonWarning: $showingLoginButtonWarning
        )
        .focused($focusedField, equals: .username)
        PasswordFieldView(
          password: $password,
          showingTwoFactorField: $showingTwoFactorField,
          passwordInvalid: $passwordInvalid,
          showingLoginButtonWarning: $showingLoginButtonWarning
        )
        .focused($focusedField, equals: .password)
      }
      .onSubmit {
        if focusedField == .username {
          focusedField = .password
        } else {
          focusedField = nil
        }
      }

      if showingTwoFactorField {
        Section {
          TwoFactorFieldView(
            twoFactor: $twoFactor,
            showingTwoFactorWarning: $showingTwoFactorWarning,
            twoFactorInvalid: $twoFactorInvalid
          )
        }
      }

      Section {
        LoginButtonView(
          isTryingLogin: $isTryingLogin,
          loggedInUsersList: $loggedInUsersList,
          loggedInEmailsList: $loggedInEmailsList,
          usernameEmailInput: $usernameEmailInput,
          password: $password,
          twoFactor: $twoFactor,
          loggedIn: $loggedIn,
          showingTwoFactorField: $showingTwoFactorField,
          showingTwoFactorWarning: $showingTwoFactorWarning,
          usernameEmailInvalid: $usernameEmailInvalid,
          passwordInvalid: $passwordInvalid,
          twoFactorInvalid: $twoFactorInvalid,
          showingPopover: $showingPopover,
          showingLoginButtonWarning: $showingLoginButtonWarning,
          isLoginFlowComplete: $isLoginFlowComplete
        )
      }

      DebugLoginPagePropertiesView(
        isTryingLogin: isTryingLogin,
        loggedIn: loggedIn,
        showingTwoFactorField: showingTwoFactorField,
        showingTwoFactorWarning: showingTwoFactorWarning,
        showingLoginButtonWarning: showingLoginButtonWarning,
        usernameEmailInvalid: usernameEmailInvalid,
        passwordInvalid: passwordInvalid,
        twoFactorInvalid: twoFactorInvalid,
        showingPopover: showingPopover
      ).font(.caption2)

    }.listStyle(.insetGrouped)
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    /// need to set showing popover to a constant value
    LoginView(showingPopover: .constant(false), isLoginFlowComplete: .constant(true))
  }
}

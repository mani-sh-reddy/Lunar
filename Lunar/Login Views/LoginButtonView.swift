//
//  LoginButtonView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SwiftUI

struct LoginButtonView: View {
  @Binding var isTryingLogin: Bool
  @Binding var loggedInUsersList: [String]
  @Binding var loggedInEmailsList: [String]
  @Binding var usernameEmailInput: String
  @Binding var password: String
  @Binding var twoFactor: String
  @Binding var loggedIn: Bool
  @Binding var showingTwoFactorField: Bool
  @Binding var showingTwoFactorWarning: Bool
  @Binding var usernameEmailInvalid: Bool
  @Binding var passwordInvalid: Bool
  @Binding var twoFactorInvalid: Bool
  @Binding var showingPopover: Bool
  @Binding var showingLoginButtonWarning: Bool
  @Binding var isLoginFlowComplete: Bool

  @State var loginButtonWarningOpacity: Double = 1

  let notificationHaptics = UINotificationFeedbackGenerator()

  /// Computed properties are re-evaluated every time one of the properties they rely on is modified.
  /// show progress view instead of Login Button if trying login
  /// **conditions that require the login button disabled:**
  /// userEmailInput is invalid
  /// password is invalid
  /// and if 2FA is needed (when showingTwoFactorField is true)
  /// if showingTwoFactorField = true, and twoFactor is invalid
  /// if showingTwoFactorField = true, and twoFactor is empty
  /// if isTryingLogin
  /// email is already logged in
  /// username is already logged in
  var loginButtonDisabled: Bool {
    if isTryingLogin { return true }
    if usernameEmailInvalid || passwordInvalid { return true }
    if showingTwoFactorField, twoFactorInvalid { return true }
    if loggedInUsersList.contains(usernameEmailInput) { return true }
    if loggedInUsersList.contains(usernameEmailInput) { return true }
    return false
  }

  let haptics = UINotificationFeedbackGenerator()

  var body: some View {
    Section {
      Button {
        let usernameEmail = usernameEmailInput.lowercased()
        if loginButtonDisabled { return }

        isLoginFlowComplete = false
        tryLogin(usernameEmail: usernameEmail, password: password, twoFactor: twoFactor)
        isLoginFlowComplete = true
      } label: {
        HStack {
          Text("Login")
            .disabled(loginButtonDisabled)
            .foregroundStyle(loginButtonDisabled ? Color.gray : Color.blue)
            .opacity(loginButtonDisabled ? 0.7 : 1)

          Spacer()

          ZStack {
            ProgressView()
              .opacity(isTryingLogin ? 1 : 0)
            if showingLoginButtonWarning {
              Group {
                Image(systemName: "lock.trianglebadge.exclamationmark.fill")
                  .font(.title2).opacity(loginButtonWarningOpacity)
                  .symbolRenderingMode(.hierarchical)
                  .foregroundStyle(.red)
                  .opacity(isTryingLogin ? 0 : 1)
              }

              .onAppear {
                let animation = Animation.easeIn(duration: 2)
                withAnimation(animation) {
                  loginButtonWarningOpacity = 0.1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                  showingLoginButtonWarning = false
                  loginButtonWarningOpacity = 1
                }
              }
            }
          }
        }
      }
    }
  }

  /// Sends the usernameEmail and password into the LoginHelper
  /// and retrives Success or Error w/Type of Error
  func tryLogin(usernameEmail: String, password: String, twoFactor: String?) {
    isTryingLogin = true

    LoginHelper(usernameEmail: usernameEmail, password: password, twoFactor: twoFactor)
      .login(completion: { isSuccessful, reply in
        isTryingLogin = false
        if isSuccessful {
          print("LOGIN SUCCESSFUL")
          haptics.notificationOccurred(.success)
          loggedIn = true
          showingPopover = false
        } else {
          notificationHaptics.notificationOccurred(.error)
          /// # Types of errors handled here:
          /// incorrect_login
          /// incorrect_totp token
          /// missing_totp_token
          /// Json deserialize error
          switch reply {
          case "incorrect_login":
            print("LOGIN FAILED - INCORRECT_CREDENTIALS")
            showingLoginButtonWarning = true

          case "incorrect_totp token":
            print("LOGIN FAILED - INCORRECT_TOTP")
            showingTwoFactorWarning = true
          case "missing_totp_token":
            print("LOGIN FAILED - MISSING_TOTP")
            withAnimation(.easeInOut) {
              showingTwoFactorWarning = true
              showingTwoFactorField = true
            }
            /// initial 2fa validity check
            /// will always be invalid
            twoFactorInvalid = true
          case "JSON_DECODE_ERROR":
            print("LOGIN FAILED - JSON_DECODE_ERROR")
            showingLoginButtonWarning = true
          default:
            print("LOGIN FAILED - ERROR_UNKNOWN")
          }
        }
      })
  }
}

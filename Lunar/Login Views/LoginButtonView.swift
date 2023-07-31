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
    @Binding var showTwoFactorFieldWarning: Bool
    @Binding var showLoginButtonWarning: Bool
    @Binding var usernameEmailInvalid: Bool
    @Binding var passwordInvalid: Bool
    @Binding var twoFactorInvalid: Bool
    @Binding var showingPopover: Bool

    /// Computed properties are re-evaluated every
    /// time one of the properties they rely on is modified.
    var loginButtonDisabled: Bool {
        if isTryingLogin { return true }
        if usernameEmailInvalid || passwordInvalid { return true }
        if showingTwoFactorField, twoFactorInvalid { return true }
        if loggedInUsersList.contains(usernameEmailInput) { return true }
        if loggedInUsersList.contains(usernameEmailInput) { return true }
        return false
    }

    private let tempWarningAnimation = Animation.easeInOut(duration: 2).repeatCount(1, autoreverses: true)

    var body: some View {
        Section {
            Button(action: {
                let usernameEmail = usernameEmailInput.lowercased()
                if loginButtonDisabled { return }

                tryLogin(usernameEmail: usernameEmail, password: password, twoFactor: twoFactor)

            }) {
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
                ZStack {
                    ProgressView().opacity(isTryingLogin ? 1 : 0)
                    Text("Login")
                        .foregroundStyle(loginButtonDisabled ? Color.gray : Color.blue)
                        .disabled(loginButtonDisabled)
                        .opacity(isTryingLogin ? 0 : 1)
                }
            }
        }
    }

    func isValidEmail(input: String) -> Bool {
        guard input.count >= 3 else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let matched: Bool = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
        let isValid = matched
        return isValid
    }

    func isValidUsername(input: String) -> Bool {
        guard input.count >= 3 else { return false }
        let regex = "[a-zA-Z0-9_]+"
        let matched = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
        let isValid = matched
        return isValid
    }

    func isValidPassword(input: String) -> Bool {
        let isValid = 10 ... 60 ~= input.count
        return isValid
    }

    func isValidTwoFactor(input: String) -> Bool {
        guard input.count == 6 else { print("inside guard")
            return false
        }
        let twoFactorRegex = "^[0-9]{6}$"
        let twoFactorMatched = NSPredicate(format: "SELF MATCHES %@", twoFactorRegex).evaluate(with: input)
        print(twoFactorMatched)
        return twoFactorMatched
    }

    /// Sends the usernameEmail and password into the LoginHelper
    /// and retrives Success or Error w/Type of Error
    func tryLogin(usernameEmail: String, password: String, twoFactor: String?) {
        isTryingLogin = true

        LoginHelper(
            usernameEmail: usernameEmail,
            password: password,
            twoFactor: twoFactor
        ).login(completion: { isSuccessful, reply in
            isTryingLogin = false
            if isSuccessful {
                print("LOGIN SUCCESSFUL")
                loggedIn = true
                showingPopover = false
            } else {
                /// # Types of errors handled here:
                /// incorrect_login
                /// incorrect_totp token
                /// missing_totp_token
                /// Json deserialize error
                switch reply {
                case "incorrect_login":
                    print("LOGIN FAILED - INCORRECT_CREDENTIALS")
                    showLoginButtonWarning = true
                case "incorrect_totp token":
                    print("LOGIN FAILED - INCORRECT_TOTP")
                    showTwoFactorFieldWarning = true
                case "missing_totp_token":
                    print("LOGIN FAILED - MISSING_TOTP")
                    showingTwoFactorField = true
                    /// initial 2fa validity check
                    /// will always be invalid
                    twoFactorInvalid = true
                case "JSON_DECODE_ERROR":
                    print("LOGIN FAILED - JSON_DECODE_ERROR")
                    showLoginButtonWarning = true
                default:
                    print("LOGIN FAILED - ERROR_UNKNOWN")
                }
            }
        })
    }
}

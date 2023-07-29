//
//  LoginView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Alamofire
import SwiftUI

struct LoginView: View {
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser

    @Environment(\.dismiss) var dismiss

    @ObservedObject var loginHelper: LoginHelper

    @State private var usernameOrEmail = ""
    @State private var password = ""
    @State private var twoFactorToken = ""
    @State private var isLoading: Bool = false
    @State private var requires2FA: Bool = false
    @State private var showPassword: Bool = false
    @State private var shakeLoginButton: Bool = false
    @State private var shake2FAField: Bool = false
    @State private var loggedIn: Bool = false

    let haptic = UINotificationFeedbackGenerator()

    var validInput: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let usernameRegex = "[a-zA-Z0-9_]+"
        let usernameMatched = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: usernameOrEmail)
        let emailMatched = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: usernameOrEmail)
        return usernameOrEmail.count >= 3 &&
            10 ... 60 ~= password.count &&
            (usernameMatched || emailMatched)
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "person").frame(width: 10)
                        .padding(.trailing)
                    TextField("Username or Email", text: $usernameOrEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                HStack {
                    Image(systemName: "key").frame(width: 10)
                        .padding(.trailing)
                    if !showPassword {
                        SecureField("Password", text: $password)
                    } else {
                        TextField("Password", text: $password)
                    }

                    Image(systemName: "\(showPassword ? "eye" : "eye.slash.fill")").foregroundStyle(showPassword ? Color.black : Color.gray)
                        .onTapGesture { showPassword.toggle() }
                }
            }
            if requires2FA {
                Section {
                    HStack {
                        Image(systemName: "person").frame(width: 10)
                            .padding(.trailing)
                        ZStack {
                            TextField("2FA Token", text: $twoFactorToken.max(6))
                                .keyboardType(.numberPad)
                                .offset(x: shake2FAField ? 5 : 0)
                        }
                    }
                }
            }

            Section {
                Button(action: {
                    if validInput, !loggedInUsersList.contains(usernameOrEmail.lowercased()) {
                        loginHelper.usernameOrEmail = usernameOrEmail.lowercased()
                        loginHelper.password = password
                        isLoading = true
                        print("LOGIN HELPER IS LOADING: \(isLoading)")
                        /// block will only run when completion handler
                        /// sigals a completes the function loginHelper.login
                        if twoFactorToken == "" {
                            loginHelper.login {
                                print("LOGIN HELPER 1 ACTIVE")
                                if loginHelper.isMissing2FAToken {
                                    withAnimation {
                                        requires2FA = true
                                    }
                                }

                                if loginHelper.logInSuccessful {
                                    haptic.notificationOccurred(.success)
                                    print("USER LOGIN SUCCESSFUL")
                                    loggedIn = true
                                    dismiss()
                                }
                                isLoading = false
                            }
                        }

                        if valid2FA(twoFactorToken) {
                            loginHelper.twoFactorToken = twoFactorToken
                            loginHelper.login {
                                print("LOGIN HELPER 2 ACTIVE")
                                if requires2FA {
                                    print("2FA TOKEN USED\(twoFactorToken)")

                                    if twoFactorToken == "" {
                                        haptic.notificationOccurred(.error)
                                        print("MISSING 2FA AFTER SHOWN TO USER")
                                        withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.2)) {
                                            shake2FAField.toggle()
                                        }
                                    }
                                    if loginHelper.loginFailed {
                                        haptic.notificationOccurred(.error)
                                        print("USER LOGIN FAILED")
                                        withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.2)) {
                                            shakeLoginButton.toggle()
                                        }
                                    }
                                    if loginHelper.logInSuccessful {
                                        haptic.notificationOccurred(.success)
                                        print("USER LOGIN SUCCESSFUL")
                                        loggedIn = true
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
                ) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            if loggedInUsersList.contains(usernameOrEmail.lowercased()), !loggedIn {
                                Text("User already logged in").disabled(true)
                                    .foregroundStyle(.green.opacity(0.5))
                            } else if !validInput {
                                Text("Login").disabled(true)
                                    .offset(x: shakeLoginButton ? 5 : 0)
                            } else {
                                Text("Login")
                            }
                        }
                        Spacer()
                    }
                }
            } footer: {
                VStack(alignment: .leading) {
                    Text("Debug Properties").textCase(.uppercase)
                    Text("isLoading: \(String(isLoading))")
                        .booleanColor(bool: isLoading)
                    Text("requires2FA: \(String(requires2FA))")
                        .booleanColor(bool: requires2FA)
                    Text("showPassword: \(String(showPassword))")
                        .booleanColor(bool: showPassword)
                    Text("shakeLoginButton: \(String(shakeLoginButton))")
                        .booleanColor(bool: shakeLoginButton)
                    Text("shake2FAField: \(String(shake2FAField))")
                        .booleanColor(bool: shake2FAField)
                    Text("loggedIn: \(String(loggedIn))")
                        .booleanColor(bool: loggedIn)
                    Text("userAlreadyInUserList: \(String(loggedInUsersList.contains(usernameOrEmail.lowercased())))")
                        .booleanColor(bool: loggedInUsersList.contains(usernameOrEmail.lowercased()))
                    Text("@AppStorage selectedUser: \(selectedUser)")
                    Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                }.if(!debugModeEnabled) { _ in
                    EmptyView()
                }
            }

        }.listStyle(.insetGrouped)
    }

    func valid2FA(_ input: String) -> Bool {
        let regex = "^[0-9]{6}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHelper = LoginHelper(usernameOrEmail: "", password: "", twoFactorToken: "")
        LoginView(loginHelper: loginHelper)
    }
}

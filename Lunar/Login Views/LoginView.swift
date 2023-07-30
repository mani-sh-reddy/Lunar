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
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    @Environment(\.dismiss) var dismiss

    @ObservedObject var loginHelper: LoginHelper

    @State private var usernameOrEmail = ""
    @State private var password = ""

    @State private var twoFactor = ""
    @State private var isLoading: Bool = false
    @State private var requires2FA: Bool = false
    @State private var showPassword: Bool = false
    @State private var shakeLoginButton: Bool = false
    @State private var shake2FAField: Bool = false
    @State private var loggedIn: Bool = false
    @State private var fetchedUsername: String = ""
    @State private var siteFetchComplete = false

    let haptic = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "person").frame(width: 10)
                        .padding(.trailing)
                    TextField("Username or Email", text: $usernameOrEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .onChange(of: usernameOrEmail) { _ in
                            if requires2FA {
                                requires2FA = false
                            }
                        }
                }
                HStack {
                    Image(systemName: "key").frame(width: 10)
                        .padding(.trailing)
                    if !showPassword {
                        SecureField("Password", text: $password)
                            .keyboardType(.asciiCapable)
                            .textInputAutocapitalization(.never)
                            .onChange(of: password) { _ in
                                if requires2FA {
                                    requires2FA = false
                                }
                            }
                    } else {
                        TextField("Password", text: $password)
                            .keyboardType(.asciiCapable)
                            .textInputAutocapitalization(.never)
                            .onChange(of: password) { _ in
                                if requires2FA {
                                    requires2FA = false
                                }
                            }
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
                            TextField("2FA Token", text: $twoFactor.max(6))
                                .keyboardType(.numberPad)
                                .offset(x: shake2FAField ? 5 : 0)
                        }
                    }
                }
            }

            Section {
                Button(action: {
                    if validUserAndPass(), !(loggedInUsersList.contains(usernameOrEmail.lowercased()) || loggedInEmailsList.contains(usernameOrEmail.lowercased())) {
                        loginHelper.usernameOrEmail = usernameOrEmail.lowercased()
                        loginHelper.password = password
                        isLoading = true
                        print("LOGIN HELPER IS LOADING: \(isLoading)")
                        /// block will only run when completion handler
                        /// sigals a completes the function loginHelper.login
                        if twoFactor == "" {
                            loginHelper.login {
                                print("LOGIN HELPER 1 ACTIVE")
                                if loginHelper.isMissing2FAToken {
                                    withAnimation {
                                        requires2FA = true
                                    }
                                }

                                if loginHelper.loginFailed {
                                    haptic.notificationOccurred(.error)
                                    print("USER LOGIN FAILED")
                                    withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.2)) {
                                        shake2FAField.toggle()
                                    }
                                    isLoading = false
                                }

                                if loginHelper.logInSuccessful {
                                    haptic.notificationOccurred(.success)
                                    print("USER LOGIN SUCCESSFUL")
                                    loggedIn = true
                                    print("selectedUser SOON AFTER USER LOGIN SUCCESSFUL: \(selectedUser)")

                                    // MARK: - LOGIN SUCCESS

                                    dismiss()
                                }
                                isLoading = false
                            }
                        }

                        if validTwoFactor() {
                            loginHelper.twoFactor = twoFactor
                            isLoading = true
                            loginHelper.login {
                                print("LOGIN HELPER 2 ACTIVE")
                                if requires2FA {
                                    print("2FA TOKEN USED\(twoFactor)")

                                    if twoFactor == "" {
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
                                            shake2FAField.toggle()
                                        }
                                        isLoading = false
                                    }
                                    if loginHelper.logInSuccessful {
                                        haptic.notificationOccurred(.success)
                                        print("USER LOGIN SUCCESSFUL")
                                        print("selectedUser SOON AFTER USER LOGIN SUCCESSFUL: \(selectedUser)")
                                        loggedIn = true
                                        isLoading = false

                                        // MARK: - LOGIN SUCCESS w/2FA

                                        dismiss()
                                    }
                                }
                                isLoading = false
                            }
                        }

                        if !validTwoFactor(), requires2FA {
                            haptic.notificationOccurred(.error)
                            print("WRONG 2FA FORMAT AFTER VISIBLE TO USER")
                            withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.2)) {
                                shake2FAField.toggle()
                            }
                            isLoading = false
                        }
                    }
                }
                ) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            if loggedInUsersList.contains(usernameOrEmail.lowercased()) ||
                                loggedInEmailsList.contains(usernameOrEmail.lowercased()),
                                !loggedIn
                            {
                                Text("User already logged in").disabled(true)
                                    .foregroundStyle(.green.opacity(0.5))
                            } else if !validUserAndPass() {
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
                DebugLoginPagePropertiesView(
                    isLoading: isLoading,
                    requires2FA: requires2FA,
                    showPassword: showPassword,
                    shakeLoginButton: shakeLoginButton,
                    shake2FAField: shake2FAField,
                    loggedIn: loggedIn,
                    usernameOrEmail: usernameOrEmail
                )
            }

        }.listStyle(.insetGrouped)
    }

    func validUserAndPass() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let usernameRegex = "[a-zA-Z0-9_]+"
        let usernameMatched = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: usernameOrEmail)
        let emailMatched = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: usernameOrEmail)
        return usernameOrEmail.count >= 3 &&
            10 ... 60 ~= password.count &&
            (usernameMatched || emailMatched)
    }

    func validTwoFactor() -> Bool {
        let twoFactorRegex = "^[0-9]{6}$"
        let twoFactorMatched = NSPredicate(format: "SELF MATCHES %@", twoFactorRegex).evaluate(with: twoFactor)
        return twoFactorMatched
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let loginHelper = LoginHelper(usernameOrEmail: "", password: "", twoFactor: "")
        LoginView(loginHelper: loginHelper)
    }
}

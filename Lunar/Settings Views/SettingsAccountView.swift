//
//  SettingsAccountView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsAccountView: View {
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

    @State private var showingPopover: Bool = false
    @State private var isPresentingConfirm: Bool = false
    @State var logoutAllUsersButtonClicked: Bool = false
    @State var logoutAllUsersButtonOpacity: Double = 1
    @State var isLoadingDeleteButton: Bool = false
    @State private var deleteConfirmationShown = false
    @State private var isConvertingEmails: Bool = false
    @State private var keychainDebugString: String = ""

    let haptic = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            if selectedUser != "" {
                Section {
                    if isConvertingEmails {
                        ProgressView()
                    } else {
                        ForEach(loggedInUsersList, id: \.self) { user in
                            Text(user)
                        }
                    }
                }
            }

            Section {
                Button(action: {
                    withAnimation(.linear(duration: 1)) {
                        showingPopover = true
                    }
                }
                ) {
                    Label {
                        Text("Add User")
                            .foregroundStyle(.blue)
                    } icon: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }

            Section {
                Button(role: .destructive, action: {
                    deleteConfirmationShown = true
                }) {
                    Label {
                        if isLoadingDeleteButton {
                            ProgressView()
                        } else {
                            Text("Logout All Users")
                                .foregroundStyle(.red)
                                .opacity(loggedInUsersList.count == 0 ? 0.4 : 1)
                        }

                        Spacer()
                        ZStack(alignment: .trailing) {
                            if logoutAllUsersButtonClicked {
                                Group {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2).opacity(logoutAllUsersButtonOpacity)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.red)
                                }.onAppear {
                                    let animation = Animation.easeIn(duration: 2)
                                    withAnimation(animation) {
                                        logoutAllUsersButtonOpacity = 0.1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        logoutAllUsersButtonClicked = false
                                        logoutAllUsersButtonOpacity = 1
                                    }
                                }
                            }
                        }
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                            .symbolRenderingMode(.hierarchical)
                            .opacity(loggedInUsersList.count == 0 ? 0.3 : 1)
                    }
                }
                .disabled(loggedInUsersList.count == 0)
                .confirmationDialog("Remove All Accounts?", isPresented: $deleteConfirmationShown) {
                    Button(role: .destructive, action: {
                        isPresentingConfirm = true
                        if loggedInUsersList.count > 0 {
                            isLoadingDeleteButton = true
                            haptic.notificationOccurred(.success)
                            logoutAllUsersButtonClicked = true

                            for userAccount in loggedInUsersList {
                                KeychainHelper.standard.delete(service: "io.github.mani-sh-reddy.Lunar.app", account: userAccount)
                                loggedInUsersList.removeAll { $0 == userAccount }
                                selectedUser = loggedInUsersList.last ?? ""
                                print("LOGGED OUT AND DELETED FROM KEYCHAIN: \(userAccount)")
                            }
                            loggedInEmailsList.removeAll()
                            print("REMOVED ALL from loggedInEmailsList")
                            KeychainHelper.standard.clearKeychain()
                            print("REMOVED ALL JWT from Keychain")

                            isLoadingDeleteButton = false
                            isPresentingConfirm = false
                        }
                    }) {
                        Text("Logout All Users")
                    }
                }
            } footer: {
                VStack(alignment: .leading, spacing: 5) {
                    Spacer()
                    Text("Debug Properties").textCase(.uppercase)
                    Group {
                        Text("showingPopover: \(String(showingPopover))")
                            .booleanColor(bool: showingPopover)
                        Text("isPresentingConfirm: \(String(isPresentingConfirm))")
                            .booleanColor(bool: isPresentingConfirm)
                        Text("logoutAllUsersButtonClicked: \(String(logoutAllUsersButtonClicked))")
                            .booleanColor(bool: logoutAllUsersButtonClicked)
                        Text("logoutAllUsersButtonOpacity: \(String(logoutAllUsersButtonOpacity))")
                        Text("isLoadingDeleteButton: \(String(isLoadingDeleteButton))")
                            .booleanColor(bool: isLoadingDeleteButton)
                        Text("deleteConfirmationShown: \(String(deleteConfirmationShown))")
                            .booleanColor(bool: deleteConfirmationShown)
                    }
                    Group {
                        Text("@AppStorage selectedUser: \(selectedUser)")
                        Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                        Text("@AppStorage loggedInEmailsList: \(loggedInEmailsList.rawValue)")
                    }

                    Group {
                        ScrollView {
                            Text("KEYCHAIN: \(keychainDebugString)").font(.caption2)
                        }
                    }

                    /// ** For Keychain Debugging**
//                    print(KeychainHelper.standard.generateDebugString(service: appBundleID).fastestEncoding.rawValue)
                }.if(!debugModeEnabled) { _ in
                    EmptyView()
                }
            }
        }
        .task {
            if debugModeEnabled {
                keychainDebugString = KeychainHelper.standard.generateDebugString(service: "io.github.mani-sh-reddy.Lunar.app")
            }
        }

        // MARK: - Converting email-based login to username-based login

        .onChange(of: loggedInUsersList) { newValue in
            var updatedList: [String] = []

            let dispatchGroup = DispatchGroup() // Create a dispatch group to track async tasks

            for account in newValue {
                if account.contains("@") {
                    dispatchGroup.enter() // Enter the dispatch group before starting the conversion

                    let emailToUsernameConverter = EmailToUsernameConverter(userEmail: account)
                    emailToUsernameConverter.convertEmailToUsername { convertedUsername in
                        if let username = convertedUsername {
                            print("Converted username: \(username)")

                            // MARK: - update keychain to use username as the account identifier

                            // Step 1: Fetch the existing password using the email-based account
                            let existingPassword = KeychainHelper.standard.read(service: appBundleID, account: account)

                            // Step 2: Delete the existing Keychain entry with the email-based account
                            KeychainHelper.standard.delete(service: appBundleID, account: account)

                            // Step 3: Save a new Keychain entry using the username as the account
                            KeychainHelper.standard.save(existingPassword, service: appBundleID, account: username)

                            updatedList.append(username) // Append the converted username
                            loggedInEmailsList.append(account)
                        } else {
                            print("Failed to convert email to username OR Not required.")
                        }

                        dispatchGroup.leave() // Leave the dispatch group after conversion is done
                    }
                } else {
                    // If the account is already a username, add it directly to the updatedList
                    updatedList.append(account)
                }
            }

            // Wait for all conversions to finish before updating loggedInUsersList
            isConvertingEmails = true
            dispatchGroup.notify(queue: .main) {
                isConvertingEmails = false
                loggedInUsersList = updatedList
                print("NEW loggedInUsersList: \(loggedInUsersList)")
                print("OLD CONVERTED loggedInEmailsList: \(loggedInEmailsList)")
            }
            if debugModeEnabled {
                keychainDebugString = KeychainHelper.standard.generateDebugString(service: "io.github.mani-sh-reddy.Lunar.app")
            }
        }

        .navigationTitle("Accounts")
        .sheet(isPresented: $showingPopover) {
            LoginView(loginHelper: LoginHelper(
                usernameOrEmail: "",
                password: "",
                twoFactorToken: ""
            ))
        }
    }
}

struct SettingsAccountView_Previews: PreviewProvider {
    static var previews: some View {
//        SettingsAccountView(siteFetcher: SiteFetcher())
        SettingsAccountView()
    }
}

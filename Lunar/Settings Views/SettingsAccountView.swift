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

    @State var showingPopover: Bool = false
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
                        // need to invalidate all inputs on first popover
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
                DebugAccountsPropertiesView(
                    showingPopover: showingPopover,
                    isPresentingConfirm: isPresentingConfirm,
                    logoutAllUsersButtonClicked: logoutAllUsersButtonClicked,
                    logoutAllUsersButtonOpacity: logoutAllUsersButtonOpacity,
                    isLoadingDeleteButton: isLoadingDeleteButton,
                    deleteConfirmationShown: deleteConfirmationShown
                )
            }
        }
        .navigationTitle("Accounts")
        .sheet(isPresented: $showingPopover) {
            LoginView(showingPopover: $showingPopover)
        }
    }
}

struct SettingsAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAccountView()
    }
}

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
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

    @State private var showingPopover: Bool = false
    @State private var isPresentingConfirm: Bool = false
    @State var logoutAllUsersButtonClicked: Bool = false
    @State var logoutAllUsersButtonOpacity: Double = 1
    @State var isLoadingDeleteButton: Bool = false
    @State private var deleteConfirmationShown = false

    let haptic = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            Section {
                Button(action: {
                    withAnimation(.linear(duration: 10)) {
                        showingPopover = true
                    }
                }, label: {
                    Text("Add New Account")
                })
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
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                            .symbolRenderingMode(.hierarchical)
                            .opacity(loggedInUsersList.count == 0 ? 0.3 : 1)
                    }
                }.disabled(loggedInUsersList.count == 0)
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
                                    print("DELETED & LOGGED OUT \(userAccount)")
                                }

                                isLoadingDeleteButton = false
                                isPresentingConfirm = false
                            }
                        }) {
                            Text("Logout All Users")
                        }
                    }
            } footer: {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Debug Properties").textCase(.uppercase)
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
                    Text("@AppStorage selectedUser: \(selectedUser)")
                    Text("@AppStorage loggedInUsersList: \(loggedInUsersList.rawValue)")
                    /// ** For Keychain Debugging**
                    /// KeychainHelper.standard.generateDebugString(service: appBundleID)
                }.if(!debugModeEnabled) { _ in
                    EmptyView()
                }
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
        SettingsAccountView()
    }
}

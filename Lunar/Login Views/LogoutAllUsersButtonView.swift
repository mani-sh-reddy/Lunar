//
//  LogoutAllUsersButtonView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Foundation
import SwiftUI

struct LogoutAllUsersButtonView: View {
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("selectedUser") var selectedUser = Settings.selectedUser

  @Binding var showingPopover: Bool
  @Binding var isPresentingConfirm: Bool
  @Binding var logoutAllUsersButtonClicked: Bool
  @Binding var logoutAllUsersButtonOpacity: Double
  @Binding var isLoadingDeleteButton: Bool
  @Binding var deleteConfirmationShown: Bool
  @Binding var isConvertingEmails: Bool
  @Binding var keychainDebugString: String
  @Binding var selectedAccount: AccountModel?

  let haptic = UINotificationFeedbackGenerator()

  var body: some View {
    Button(role: .destructive) {
      deleteConfirmationShown = true
    } label: {
      Label {
        if isLoadingDeleteButton {
          ProgressView()
        } else {
          Text("Logout All Users")
            .foregroundStyle(.red)
            .opacity(loggedInAccounts.isEmpty ? 0.4 : 1)
        }

        Spacer()
        ZStack(alignment: .trailing) {
          if logoutAllUsersButtonClicked {
            Group {
              Image(systemName: "checkmark.circle.fill")
                .font(.title2).opacity(logoutAllUsersButtonOpacity)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.green)
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
          .opacity(loggedInAccounts.isEmpty ? 0.3 : 1)
      }
    }
    .disabled(loggedInAccounts.isEmpty)
    .confirmationDialog("Remove All Accounts?", isPresented: $deleteConfirmationShown) {
      Button(role: .destructive) {
        isPresentingConfirm = true
        if !loggedInAccounts.isEmpty {
          selectedAccount = AccountModel(
            userID: "", name: "", email: "", avatarURL: "", actorID: ""
          )
          loggedInAccounts.removeAll()
          selectedName = ""
          selectedEmail = ""
          selectedAvatarURL = ""
          selectedActorID = ""
          selectedUser = []

          isLoadingDeleteButton = true
          haptic.notificationOccurred(.success)
          logoutAllUsersButtonClicked = true

          KeychainHelper.standard.clearKeychain()
          UserDefaults.standard.synchronize()
          print("REMOVED ALL JWT from Keychain")

          for account in loggedInAccounts {
            KeychainHelper.standard.delete(
              service: appBundleID,
              account: account.actorID
            )
          }
          loggedInAccounts.removeAll()
          isLoadingDeleteButton = false
          isPresentingConfirm = false
        }
      } label: {
        Text("Logout All Users")
      }
    }
  }
}

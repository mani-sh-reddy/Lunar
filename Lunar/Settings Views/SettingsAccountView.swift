//
//  SettingsAccountView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import SwiftUI

struct SettingsAccountView: View {
  @State var showingPopover: Bool = false
  @State var isPresentingConfirm: Bool = false
  @State var logoutAllUsersButtonClicked: Bool = false
  @State var logoutAllUsersButtonOpacity: Double = 1
  @State var isLoadingDeleteButton: Bool = false
  @State var deleteConfirmationShown = false
  @State var isConvertingEmails: Bool = false
  @State var keychainDebugString: String = ""
  @State var isLoginFlowComplete: Bool = true

  var body: some View {
    List {
      Section {
        if isLoginFlowComplete {
          LoggedInUsersListView()
        } else {
          HStack {
            ProgressView()
              .padding(.trailing, 5)
            Text("Loading Users")
          }
        }
      }

      Section {
        AddNewUserButtonView(
          showingPopover: $showingPopover
        )

        LogoutAllUsersButtonView(
          showingPopover: $showingPopover,
          isPresentingConfirm: $isPresentingConfirm,
          logoutAllUsersButtonClicked: $logoutAllUsersButtonClicked,
          logoutAllUsersButtonOpacity: $logoutAllUsersButtonOpacity,
          isLoadingDeleteButton: $isLoadingDeleteButton,
          deleteConfirmationShown: $deleteConfirmationShown,
          isConvertingEmails: $isConvertingEmails,
          keychainDebugString: $keychainDebugString
        )
      }

      DebugAccountsPropertiesView(
        showingPopover: showingPopover,
        isPresentingConfirm: isPresentingConfirm,
        logoutAllUsersButtonClicked: logoutAllUsersButtonClicked,
        logoutAllUsersButtonOpacity: logoutAllUsersButtonOpacity,
        isLoadingDeleteButton: isLoadingDeleteButton,
        deleteConfirmationShown: deleteConfirmationShown
      )
    }
    .navigationTitle("Accounts")
    .sheet(isPresented: $showingPopover) {
      LoginView(
        showingPopover: $showingPopover,
        isLoginFlowComplete: $isLoginFlowComplete
      )
    }
  }
}

struct SettingsAccountView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsAccountView()
  }
}

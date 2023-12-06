//
//  SettingsAccountView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import SwiftUI

struct SettingsAccountView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.selectedInstance) var selectedInstance

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
      if !activeAccount.actorID.isEmpty, selectedInstance != URLParser.extractDomain(from: activeAccount.actorID) {
        Section {
          VStack(spacing: 10) {
            Text("Note: If the current user's home instance differs from the selected instance, errors may occur while attempting actions such as voting, replying, or blocking.")
            HStack {
              Spacer()
              Image(systemSymbol: .exclamationmarkTriangleFill).symbolRenderingMode(.multicolor)
              Text("\(URLParser.extractDomain(from: activeAccount.actorID)) x \(selectedInstance)")
                .padding(.vertical, 10)
              Spacer()
            }
          }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .font(.caption)
        .foregroundStyle(.gray)
      }

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

#Preview {
  SettingsAccountView()
}

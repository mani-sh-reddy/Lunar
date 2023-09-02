//
//  UsernameFieldView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SwiftUI

struct UsernameFieldView: View {
  @Binding var usernameEmailInput: String
  @Binding var showingTwoFactorField: Bool
  @Binding var usernameEmailInvalid: Bool
  @Binding var showingLoginButtonWarning: Bool

  var body: some View {
    Label {
      TextField("Username or Email", text: $usernameEmailInput)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .textContentType(.emailAddress)
    } icon: {
      Image(systemName: "person")
        .foregroundStyle(.foreground)
    }
    .onAppear {
      if let devUsername = ProcessInfo.processInfo.environment["LEMMY_TEST_ACC_2_USER"] {
        usernameEmailInput = devUsername
      }
    }
    .onDebouncedChange(of: $usernameEmailInput, debounceFor: 0.25) { newValue in
      showingTwoFactorField = false
      showingLoginButtonWarning = false
      usernameEmailInvalid =
        !ValidationUtils.isValidUsername(input: newValue)
          && !ValidationUtils.isValidEmail(input: newValue)
    }
  }
}

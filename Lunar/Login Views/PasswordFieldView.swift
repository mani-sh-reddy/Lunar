//
//  PasswordFieldView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct PasswordFieldView: View {
  @Binding var password: String
  @Binding var showingTwoFactorField: Bool
  @Binding var passwordInvalid: Bool
  @Binding var showingLoginButtonWarning: Bool

  @State var uncoverPassword: Bool = false

  var body: some View {
    HStack {
      Label {
        if uncoverPassword {
          TextField("Password", text: $password)
            .keyboardType(.asciiCapable)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textContentType(.password)
        } else {
          SecureField("Password", text: $password)
            .keyboardType(.asciiCapable)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textContentType(.password)
        }
      } icon: {
        Image(systemSymbol: .key)
          .foregroundStyle(.foreground)
      }
      Button {
        uncoverPassword.toggle()
      } label: {
        Image(systemSymbol: uncoverPassword ? .eyesInverse : .eyeSlash)
          .symbolRenderingMode(.hierarchical)
          .foregroundStyle(.foreground)
          .padding(.leading, 10)
      }
    }
    .onDebouncedChange(of: $password, debounceFor: 0.25) { newValue in
      showingTwoFactorField = false
      showingLoginButtonWarning = false
      passwordInvalid = !ValidationUtils.isValidPassword(input: newValue)
    }
  }
}

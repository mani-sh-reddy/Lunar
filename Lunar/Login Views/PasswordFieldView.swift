//
//  PasswordFieldView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
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
                Image(systemName: "key")
                    .foregroundStyle(.foreground)
            }
            Button(action: {
                uncoverPassword.toggle()
            }, label: {
                Image(systemName: uncoverPassword ? "eye.circle.fill" : "eye.slash.circle")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.foreground)
                    .padding(.leading, 10)
            })
        }
        .onAppear {
            if let devPassword = ProcessInfo.processInfo.environment["LEMMY_TEST_ACC_PASS"] {
                password = devPassword
            }
        }
        .onDebouncedChange(of: $password, debounceFor: 0.1) { newValue in
            showingTwoFactorField = false
            showingLoginButtonWarning = false
            passwordInvalid = !ValidationUtils.isValidPassword(input: newValue)
        }
    }
}

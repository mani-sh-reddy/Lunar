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

    var body: some View {
        HStack {
            Image(systemName: "key").frame(width: 10)
                .padding(.trailing)
//            if !showPassword {
            if true {
                SecureField("Password", text: $password)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
//                    .onChange(of: password) { _ in
//                        if requires2FA {
//                            requires2FA = false
//                        }
//                    }
            } else {
                TextField("Password", text: $password)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

//            Image(systemName: "\(showPassword ? "eye" : "eye.slash.fill")").foregroundStyle(showPassword ? Color.black : Color.gray)
//                .onTapGesture { showPassword.toggle() }
        }
        .onAppear {
            if let devPassword = ProcessInfo.processInfo.environment["LEMMY_TEST_ACC_PASS"] {
                password = devPassword
            }
        }
        .onChange(of: password) { newValue in
            showingTwoFactorField = false
            passwordInvalid = !ValidationUtils.isValidPassword(input: newValue)
        }
    }
}

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
//    @Binding var requires2FA: Bool

    var body: some View {
        HStack {
            Image(systemName: "person").frame(width: 10)
                .padding(.trailing)
            TextField("Username or Email", text: $usernameEmailInput)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .onAppear {
            if let devUsername = ProcessInfo.processInfo.environment["LEMMY_TEST_ACC_2_USER"] {
                usernameEmailInput = devUsername
            }
        }
        .onChange(of: usernameEmailInput) { newValue in
            showingTwoFactorField = false
            usernameEmailInvalid = !ValidationUtils.isValidUsername(input: newValue) && !ValidationUtils.isValidEmail(input: newValue)
        }
    }
}

//
//  TwoFactorFieldView.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation
import SwiftUI

struct TwoFactorFieldView: View {
    @Binding var twoFactor: String
    @Binding var showTwoFactorFieldWarning: Bool
    @Binding var twoFactorInvalid: Bool

    var body: some View {
        Section {
            HStack {
                Image(systemName: "lock.shield").frame(width: 10)
                    .padding(.trailing)
                ZStack {
                    TextField("2FA Token", text: $twoFactor)
                        .keyboardType(.numberPad)
                }
            }
            .onChange(of: twoFactor) { newValue in
                twoFactorInvalid = !ValidationUtils.isValidTwoFactor(input: newValue)
            }
        }
    }
}

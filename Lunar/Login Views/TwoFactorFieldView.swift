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
    @Binding var showingTwoFactorWarning: Bool
    @Binding var twoFactorInvalid: Bool

    @State var twoFactorWarningOpacity: Double = 0

    var body: some View {
        HStack {
            Label {
                TextField("2FA Token", text: $twoFactor)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.oneTimeCode)
            } icon: {
                Image(systemName: "shield")
                    .foregroundStyle(.foreground)
            }
            .onDebouncedChange(of: $twoFactor, debounceFor: 0.1) { newValue in
                showingTwoFactorWarning = false
                twoFactorInvalid = !ValidationUtils.isValidTwoFactor(input: newValue)
            }
            Spacer()
            if showingTwoFactorWarning {
                Group {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2).opacity(twoFactorWarningOpacity)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.red)
                }
                .onAppear {
                    let animation = Animation.easeIn(duration: 2)
                    withAnimation(animation) {
                        twoFactorWarningOpacity = 0.1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showingTwoFactorWarning = false
                        twoFactorWarningOpacity = 1
                    }
                }
            }
        }
    }
}

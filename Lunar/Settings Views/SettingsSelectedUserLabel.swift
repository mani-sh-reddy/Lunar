//
//  SettingsSelectedUserLabel.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import SwiftUI

struct SettingsSelectedUserLabel: View {
    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

    @Binding var selectedName: String
    @Binding var selectedEmail: String
    @Binding var selectedUserURL: String

    var body: some View {
        if selectedName == "" {
            HStack(alignment: .center) {
                Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                    .font(.system(size: 50))
                    .padding(.trailing, 10)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.gray)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: "Sign In")
                        .fontWeight(.bold)
                        .font(.title)
                }
            }

        } else {
            HStack(alignment: .center) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: selectedName)
                        .fontWeight(.bold)
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    Text(selectedEmail)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 5)

                    Text(selectedUserURL)
                        .foregroundStyle(.tertiary)
                        .padding(.bottom, 5)
                }
            }
        }
    }
}

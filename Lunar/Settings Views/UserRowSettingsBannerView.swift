//
//  UserRowSettingsBannerView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation
import SwiftUI

struct UserRowSettingsBannerView: View {
    @AppStorage("selectedUserID") var selectedUserID = Settings.selectedUserID
    @AppStorage("selectedName") var selectedName = Settings.selectedName
    @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
    @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

    @Binding var selectedAccount: LoggedInAccount?

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                .foregroundStyle(.blue)
                .symbolRenderingMode(.hierarchical)

            if selectedActorID == "" {
                Text("Sign In").font(.title2).bold()
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text(selectedName).font(.title2).bold()
                    Text("@\(URLParser.extractDomain(from: selectedActorID))").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}

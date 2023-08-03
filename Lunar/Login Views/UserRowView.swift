////
////  UserRowView.swift
////  Lunar
////
////  Created by Mani on 28/07/2023.
////
//
// import Foundation
// import SwiftUI
//
// struct UserRowView: View {
//    @AppStorage("selectedUserID") var selectedUserID = Settings.selectedUserID
//    @AppStorage("selectedName") var selectedName = Settings.selectedName
//    @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
//    @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
//    @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
//
//    @Binding var selectedAccount: LoggedInAccount
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 3) {
//                Text(selectedName).font(.title2).bold()
//                Text("@\(URLParser.extractDomain(from: selectedActorID))")
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//            }.foregroundStyle(.foreground)
//            Spacer()
//            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                .font(.title2)
//                .symbolRenderingMode(.hierarchical)
//                .foregroundStyle(.indigo)
//        }
//    }
// }

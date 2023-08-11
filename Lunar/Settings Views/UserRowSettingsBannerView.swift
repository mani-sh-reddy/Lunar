//
//  UserRowSettingsBannerView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation
import Nuke
import NukeUI
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
      if !selectedAvatarURL.isEmpty {
        LazyImage(url: URL(string: selectedAvatarURL)) { state in
          if let image = state.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(alignment: .center)
              .frame(width: 50, height: 50)
              .clipShape(.circle)
              .padding(.trailing, 10)
          } else {
            ProgressView()
          }
        }
      } else {
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .frame(width: 50, height: 50)
          .padding(.trailing, 10)
          .foregroundStyle(.blue)
          .symbolRenderingMode(.hierarchical)
      }

      if selectedActorID.isEmpty {
        Text("Sign In").font(.title2).bold()
      } else {
        VStack(alignment: .leading, spacing: 3) {
          Text(selectedName).font(.title2).bold()
          Text("@\(URLParser.extractDomain(from: selectedActorID))")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

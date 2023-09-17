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
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail

  @Binding var selectedAccount: AccountModel?

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
              .clipShape(Circle())
              .padding(.trailing, 10)
          } else {
            Image(systemSymbol: .personCropCircleFill)
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundStyle(.blue)
              .symbolRenderingMode(.hierarchical)
              .padding(.trailing, 10)
          }
        }
      } else {
        Image(systemSymbol: .personCropCircleFill)
          .resizable()
          .frame(width: 50, height: 50)
          .padding(.trailing, 10)
          .foregroundStyle(.gray)
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

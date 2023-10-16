//
//  UserRowSettingsBannerView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Defaults
import Foundation
import Nuke
import NukeUI
import SwiftUI

struct UserRowSettingsBannerView: View {
  @Default(.activeAccount) var activeAccount

  @Binding var selectedAccount: AccountModel?

  var body: some View {
    HStack {
      if !activeAccount.avatarURL.isEmpty {
        LazyImage(url: URL(string: activeAccount.avatarURL)) { state in
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
        .pipeline(ImagePipeline.shared)
      } else {
        Image(systemSymbol: .personCropCircleFill)
          .resizable()
          .frame(width: 50, height: 50)
          .padding(.trailing, 10)
          .foregroundStyle(.gray)
          .symbolRenderingMode(.hierarchical)
      }

      if activeAccount.actorID.isEmpty {
        Text("Sign In").font(.title2).bold()
      } else {
        VStack(alignment: .leading, spacing: 3) {
          Text(activeAccount.name).font(.title2).bold()
          Text("@\(URLParser.extractDomain(from: activeAccount.actorID))")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

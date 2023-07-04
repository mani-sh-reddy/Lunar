//
//  AccountItemView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Defaults
import Foundation
import Nuke
import NukeUI
import SwiftUI

struct AccountItemView: View {
  var account: AccountModel

  var body: some View {
    HStack {
      if !account.avatarURL.isEmpty {
        LazyImage(url: URL(string: account.avatarURL)) { state in
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

      if account.actorID.isEmpty {
        Text("Sign In").font(.title2).bold()
      } else {
        VStack(alignment: .leading, spacing: 3) {
          Text(account.name).font(.title2).bold()
          Text("@\(URLParser.extractDomain(from: account.actorID))")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

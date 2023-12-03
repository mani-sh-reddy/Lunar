//
//  GeneralCommunityButtonView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct GeneralCommunityQuicklinkButton: View {
  @Default(.enableQuicklinks) var enableQuicklinks

  @Environment(\.colorScheme) var colorScheme

  let image: String
  let hexColor: String
  let title: String
  let brightness: Double
  let saturation: Double
  let type: String
  let sort: String

  var body: some View {
    HStack {
      Image(systemName: image) /// Cannot use SFSafeSymbols due to @AppStorage
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color(hex: hexColor) ?? .gray)
        .brightness(colorScheme == .light ? -brightness : brightness)
        .saturation(saturation)
      Text(title)
        .padding(.horizontal, 10)
      Spacer()
      if enableQuicklinks {
        HStack {
          switch type {
          case "Local":
            Image(systemSymbol: .houseFill)
              .opacity(0.6)
          case "All":
            Image(systemSymbol: .globeAmericasFill)
              .opacity(0.6)
          case "Subscribed":
            Image(systemSymbol: .bookmarkFill)
              .opacity(0.6)
          default:
            Image(systemSymbol: .circle)
              .opacity(0.6)
          }
          Text(sort)
            .bold()
        }
        .font(.caption)
        .foregroundStyle(.gray)
        .opacity(0.9)
      }
    }
  }
}

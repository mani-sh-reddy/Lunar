//
//  GeneralCommunityButtonView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct GeneralCommunityQuicklinkButton: View {
  @Environment(\.colorScheme) var colorScheme
  let image: String
  let hexColor: String
  let title: String
  let brightness: Double
  let saturation: Double

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
    }
  }
}

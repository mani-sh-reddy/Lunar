//
//  GeneralCommunityButtonView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SwiftUI

struct GeneralCommunityQuicklinkButton: View {
  @Environment(\.colorScheme) var colorScheme
  let image: String
  let hexColor : String
  let title: String
  
  var body: some View {
    HStack {
      Image(systemName: image)
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color(hex: hexColor) ?? .gray)
        .brightness(colorScheme == .light ? -0.3 : 0.3)
        .saturation(colorScheme == .light ? 2 : 2)
      Text(title)
        .padding(.horizontal, 10)
    }
  }
}

//
//  LargeNavButton.swift
//  Lunar
//
//  Created by Mani on 03/09/2023.
//

import SwiftUI

enum SymbolLocation {
  case left
  case right
}

struct SmallNavButton: View {
  var systemImage: String
  var text: String
  var color: Color
  var symbolLocation: SymbolLocation

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      if symbolLocation == .right {
        Text(text)
      }
      Image(systemName: systemImage)
        .imageScale(.small)
      if symbolLocation == .left {
        Text(text)
      }
    }
    .foregroundColor(color)
    .font(.subheadline)
  }
}

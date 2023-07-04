//
//  SmallNavButton.swift
//  Lunar
//
//  Created by Mani on 03/09/2023.
//

import SFSafeSymbols
import SwiftUI

enum SymbolLocation {
  case left
  case right
}

struct SmallNavButton: View {
  var systemSymbol: SFSafeSymbols.SFSymbol
  var text: String
  var color: Color
  var symbolLocation: SymbolLocation

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      if symbolLocation == .right {
        Text(text)
      }
      Image(systemSymbol: systemSymbol)
        .imageScale(.small)
      if symbolLocation == .left {
        Text(text)
      }
    }
    .foregroundColor(color)
    .font(.subheadline)
  }
}

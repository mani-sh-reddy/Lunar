//
//  PostButtonItem.swift
//  Lunar
//
//  Created by Mani on 20/10/2023.
//

import SFSafeSymbols
import SwiftUI

struct PostButtonItem: View {
  var text: String = ""
  var icon: SFSafeSymbols.SFSymbol
  var color: Color
  var textSize: Font = .subheadline
  var iconSize: Font = .body
  var padding: CGFloat = 5

  var active: Bool?
  var opposite: Bool?

  var background: Color {
    if active == true {
      color.opacity(0.75)
    } else if active == false {
      .secondary.opacity(0.1)
    } else {
      .secondary.opacity(0.1)
    }
  }

  var foreground: Color {
    if active == true {
      Color.white
    } else if active == false {
      color
    } else {
      color
    }
  }

  var rendering: SymbolRenderingMode {
    if active == true {
      .monochrome
    } else if active == false {
      .hierarchical
    } else {
      .hierarchical
    }
  }

  var body: some View {
    HStack(spacing: 3) {
      Image(systemSymbol: icon)
        .font(iconSize)
      if !text.isEmpty {
        Text(text)
          .font(textSize)
          .padding(.trailing, 3)
      }
    }
    .foregroundStyle(foreground)
    .symbolRenderingMode(rendering)
    .lineLimit(1)
    .buttonStyle(BorderlessButtonStyle())
    .padding(padding)
    .background(background, in: Capsule())
    .padding(.top, 3)
  }
}

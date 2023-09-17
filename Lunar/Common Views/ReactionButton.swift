//
//  ReactionButton.swift
//  Lunar
//
//  Created by Mani on 15/08/2023.
//

import SwiftUI
import SFSafeSymbols

struct ReactionButton: View {
  var text: String = ""
  var icon: SFSafeSymbols.SFSymbol
  var color: Color
  var textSize: Font = .subheadline
  var iconSize: Font = .body
  var padding: CGFloat = 5

  @Binding var active: Bool
  @Binding var opposite: Bool

  var body: some View {
    Button {
      //      active.toggle()
      //      opposite = false
      //      haptics.impactOccurred()
    } label: {
      HStack {
        Image(systemSymbol: icon)
          .font(iconSize)
        if !text.isEmpty {
          Text(text)
            .font(textSize)
            .padding(.trailing, 3)
        }
      }
      .foregroundStyle(active ? Color.white : color)
      .symbolRenderingMode(
        active ? SymbolRenderingMode.monochrome : SymbolRenderingMode.hierarchical
      )
    }.lineLimit(1)
      .buttonStyle(BorderlessButtonStyle())
      .padding(padding)
      .background(active ? color.opacity(0.75) : .secondary.opacity(0.1), in: Capsule())
      .padding(.top, 3)
  }
}

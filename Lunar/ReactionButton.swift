//
//  ReactionButton.swift
//  Lunar
//
//  Created by Mani on 15/08/2023.
//

import SwiftUI

struct ReactionButton: View {
  var text: String
  var icon: String
  var color: Color
  var textSize: Font = Font.subheadline
  var iconSize: Font = Font.body
  
  @Binding var active: Bool
  @Binding var opposite: Bool
  
  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  
  var body: some View {
    Button {
      active.toggle()
      opposite = false
      haptics.impactOccurred()
    } label: {
      HStack {
        Image(systemName: icon)
          .font(iconSize)
        Text(text)
          .font(textSize)
      }
      .foregroundStyle(active ? Color.white : color)
      .symbolRenderingMode(
        active ? SymbolRenderingMode.monochrome : SymbolRenderingMode.hierarchical
      )
    }
    .buttonStyle(BorderlessButtonStyle())
    .padding(5).padding(.trailing, 3)
    .background(active ? color.opacity(0.75) : .secondary.opacity(0.1), in: Capsule())
    .padding(.top, 3)
  }
}

//
//  InPostMetadataView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct InPostMetadataView: View {
  var bodyText: String
  var iconName: SFSafeSymbols.SFSymbol
  var iconColor: Color

  var body: some View {
    HStack(alignment: .center, spacing: 1) {
      Image(systemSymbol: iconName)
        .font(.headline)
        .symbolRenderingMode(.hierarchical)
      Text(String(bodyText))
        .textCase(.uppercase)
    }
    .foregroundColor(iconColor)
    .font(.subheadline)
    .padding(.vertical, 2)
    .padding(.horizontal, 2)
    .padding(.trailing, 5)
    .lineLimit(1)
    .background {
      Capsule().foregroundStyle(.regularMaterial)
    }
  }
}

struct InPostMetadataView_Previews: PreviewProvider {
  static var previews: some View {
    HStack(spacing: 6) {
      InPostMetadataView(
        bodyText: String("3428"),
        iconName: .arrowUp,
        iconColor: .green
      )
      InPostMetadataView(
        bodyText: String("34"),
        iconName: .arrowDown,
        iconColor: .red
      )
      InPostMetadataView(
        bodyText: String("142"),
        iconName: .textBubble,
        iconColor: .gray
      )
    }
  }
}

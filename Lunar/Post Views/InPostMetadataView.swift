//
//  InPostMetadataView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

struct InPostMetadataView: View {
  var bodyText: String
  var iconName: String
  var iconColor: Color

  var body: some View {
    HStack(alignment: .center, spacing: 1) {
      Image(systemName: iconName)
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
        iconName: "arrow.up",
        iconColor: .green
      )
      InPostMetadataView(
        bodyText: String("34"),
        iconName: "arrow.down",
        iconColor: .red
      )
      InPostMetadataView(
        bodyText: String("142"),
        iconName: "text.bubble",
        iconColor: .gray
      )
    }
  }
}

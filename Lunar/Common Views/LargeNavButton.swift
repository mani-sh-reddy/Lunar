//
//  LargeNavButton.swift
//  Lunar
//
//  Created by Mani on 03/09/2023.
//

import SwiftUI

struct LargeNavButton: View {
  var text: String
  var color: Color

  var body: some View {
    Text(text)
      .font(.callout.bold())
      .padding()
      .frame(maxWidth: .infinity)
      .clipped()
      .foregroundColor(.white)
      .background(color)
      .mask { RoundedRectangle(cornerRadius: 16, style: .continuous) }
  }
}

//
//  UpvoteButtonView.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//

import SwiftUI

struct UpvoteButtonView: View {
  @Binding var isClicked: Bool

  var body: some View {
    Button {
      isClicked = true
    } label: {
      Image(systemName: "arrow.up.circle")
    }
    .tint(.green)
  }
}

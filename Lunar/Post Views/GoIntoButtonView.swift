//
//  GoIntoButtonView.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//

import SwiftUI

struct GoIntoButtonView: View {
  @Binding var isClicked: Bool

  var body: some View {
    Button {
      isClicked = true
    } label: {
      Image(systemName: "chevron.forward.circle.fill")
    }
    .tint(.blue)
  }
}

//
//  DismissButtonView.swift
//  Lunar
//
//  Created by Mani on 15/10/2023.
//

import Foundation
import SwiftUI

struct DismissButtonView: View {
  @Binding var dismisser: Bool
  var body: some View {
    Section {
      HStack {
        Spacer()
        SmallNavButton(systemSymbol: .arrowDownToLine, text: "Dismiss", color: .red, symbolLocation: .left)
          .onTapGesture {
            dismisser = false
          }
        Spacer()
      }
    }
    .listRowBackground(Color.clear)
  }
}

//
//  ConditionalListRowBackgroundModifier.swift
//  Lunar
//
//  Created by Mani on 18/09/2023.
//

import Foundation
import Shiny
import SwiftUI

enum ConditionalListRowBackground: String, CaseIterable {
  case iridescent
  case defaultBackground
}

struct ConditionalListRowBackgroundModifier: ViewModifier {
  let background: ConditionalListRowBackground

  func body(content: Content) -> some View {
    if background == .iridescent {
      AnyView(content.listRowBackground(
        ZStack {
          Color.gray.opacity(0.1)
          Rectangle().shiny(.iridescent)
        }
      ))
    } else if background == .defaultBackground {
      AnyView(content)
    } else {
      AnyView(content)
    }
  }
}

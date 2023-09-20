//
//  ConditionalListStyleModifier.swift
//  Lunar
//
//  Created by Mani on 18/09/2023.
//

import Foundation
import SwiftUI

enum ConditionalListStyle: String, CaseIterable {
  case insetGrouped
  case grouped
}

struct ConditionalListStyleModifier: ViewModifier {
  let listStyle: String

  func body(content: Content) -> some View {
    if listStyle == "insetGrouped" {
      return AnyView(content.listStyle(.insetGrouped))
    } else if listStyle == "grouped" {
      return AnyView(content.listStyle(.grouped))
    } else if listStyle == "plain" {
      return AnyView(content.listStyle(.plain))
    } else {
      return AnyView(content.listStyle(.automatic))
    }
  }
}

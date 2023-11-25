//
//  ConditionalModifiers.swift
//  Lunar
//
//  Created by Mani on 18/09/2023.
//

import Foundation
import SwiftUI

// MARK: - ConditionalListStyle

// periphery:ignore
enum ConditionalListStyle: String, CaseIterable {
  case insetGrouped
  case grouped
}

struct ConditionalListStyleModifier: ViewModifier {
  let listStyle: String

  func body(content: Content) -> some View {
    if listStyle == "insetGrouped" {
      AnyView(content.listStyle(.insetGrouped))
    } else if listStyle == "grouped" {
      AnyView(content.listStyle(.grouped))
    } else if listStyle == "plain" {
      AnyView(content.listStyle(.plain))
    } else {
      AnyView(content.listStyle(.automatic))
    }
  }
}

// MARK: - ConditionalListRowBackground

enum ConditionalListRowBackground: String, CaseIterable {
  case iridescent
  case defaultBackground
}

struct ConditionalListRowBackgroundModifier: ViewModifier {
  let background: ConditionalListRowBackground

  func body(content: Content) -> some View {
    if background == .iridescent {
      AnyView(
        content.listRowBackground(
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

// MARK: - BlurredAndDisabledModifier

enum BlurredAndDisabledStyle: String, CaseIterable {
  case none
  case disabled
  case blurAndDisabled
}

struct BlurredAndDisabledModifier: ViewModifier {
  let style: BlurredAndDisabledStyle

  func body(content: Content) -> some View {
    if style == .blurAndDisabled {
      AnyView(content)
        .blur(radius: 3)
        .disabled(true)
    } else if style == .none {
      AnyView(content)
    } else if style == .disabled {
      AnyView(content)
        .disabled(true)
    } else {
      AnyView(content)
    }
  }
}

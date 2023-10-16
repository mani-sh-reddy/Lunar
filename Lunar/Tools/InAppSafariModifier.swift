//
//  InAppSafariModifier.swift
//  Lunar
//
//  Created by Mani on 18/09/2023.
//

import BetterSafariView
import Foundation
import SwiftUI

extension View {
  func inAppSafari(isPresented: Binding<Bool>, stringURL: String) -> some View {
    modifier(InAppSafariModifier(isPresented: isPresented, stringURL: stringURL))
  }
}

struct InAppSafariModifier: ViewModifier {
  @Binding var isPresented: Bool

  let stringURL: String
  let defaultURL = "https://github.com/mani-sh-reddy/Lunar"

  func body(content: Content) -> some View {
    content
      .safariView(isPresented: $isPresented) {
        BetterSafariView.SafariView(
          url: URL(string: stringURL) ?? URL(string: defaultURL)!,
          configuration: BetterSafariView.SafariView.Configuration(
            entersReaderIfAvailable: false,
            barCollapsingEnabled: true
          )
        )
        .dismissButtonStyle(.close)
      }
  }
}

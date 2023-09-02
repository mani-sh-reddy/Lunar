//
//  ForceAppearance.swift
//  Lunar
//
//  Created by Mani on 30/08/2023.
//

import Foundation
import SwiftUI

enum AppearanceOptions: String, CaseIterable {
  case system, light, dark
}

class AppearanceController {
  static let shared = AppearanceController()
  @AppStorage("appAppearance") var appAppearance: AppearanceOptions = .system

  var appearance: UIUserInterfaceStyle {
    switch appAppearance {
    case .system:
      return .unspecified // Uses appearance set by user in Settings
    case .light:
      return .light
    case .dark:
      return .dark
    }
  }

  func setAppearance() {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    guard let window = windowScene?.windows.first else { return }
    window.overrideUserInterfaceStyle = appearance
  }
}

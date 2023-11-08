//
//  ShareSheet.swift
//  Lunar
//
//  Created by Mani on 08/11/2023.
//

import Foundation
import SwiftUI

class ShareSheet {
  func share(items: [Any]) {
    DispatchQueue.global(qos: .userInitiated).async {
      let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
      DispatchQueue.main.async {
        UIApplication.keyWindow?.rootViewController?.present(activityController, animated: true, completion: nil)
      }
    }
  }
}

extension UIApplication {
  static let keyWindow = keyWindowScene?.windows.filter(\.isKeyWindow).first
  static let keyWindowScene =
    shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
}

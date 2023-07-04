//
//  ShareSheet.swift
//  Lunar
//
//  Created by Mani on 08/11/2023.
//

import Foundation
import SwiftUI

class ShareSheet: ObservableObject {
  @Published var isSharing: Bool = false

  func share(items: [Any], completion: @escaping () -> Void) {
    isSharing = true

    DispatchQueue.global(qos: .userInteractive).async {
      let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)

      DispatchQueue.main.async {
        if let rootViewController = UIApplication.keyWindow?.rootViewController {
          activityController.completionWithItemsHandler = { _, _, _, _ in
            DispatchQueue.main.async {
              self.isSharing = false
              completion()
            }
          }
          rootViewController.present(activityController, animated: true, completion: nil)
        }
      }
    }
  }
}

extension UIApplication {
  static let keyWindow = keyWindowScene?.windows.filter(\.isKeyWindow).first
  static let keyWindowScene =
    shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
}

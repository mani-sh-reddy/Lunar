//
//  ShareSheet.swift
//  Lunar
//
//  Created by Mani on 27/08/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
  static let keyWindow = keyWindowScene?.windows.filter(\.isKeyWindow).first
  static let keyWindowScene =
    shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
}

extension View {
  func shareSheet(isPresented: Binding<Bool>, items: [Any]) -> some View {
    guard isPresented.wrappedValue else { return self }
    let activityViewController = UIActivityViewController(
      activityItems: items, applicationActivities: nil
    )
    let presentedViewController =
      UIApplication.keyWindow?.rootViewController?.presentedViewController
        ?? UIApplication.keyWindow?.rootViewController
    activityViewController.completionWithItemsHandler = { _, _, _, _ in
      isPresented.wrappedValue = false
    }
    presentedViewController?.present(activityViewController, animated: true)
    return self
  }
}

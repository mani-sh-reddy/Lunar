//
//  Biometrics.swift
//  Lunar
//
//  Created by Mani on 09/11/2023.
//

import Foundation
import LocalAuthentication
import SwiftUI

// periphery:ignore
class Biometrics: ObservableObject {
  @Published var appUnlocked = false
  @Published var authorizationError: Error?

  func requestBiometricUnlock() {
    let context = LAContext()

    var error: NSError? = nil

    let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

    if canEvaluate {
      if context.biometryType != .none {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock and view") { success, error in
          DispatchQueue.main.async {
            self.appUnlocked = success
            self.authorizationError = error
          }
        }
      }
    }
  }
}

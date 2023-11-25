//
//  CheckBiometricType.swift
//  Lunar
//
//  Created by Mani on 10/11/2023.
//

import Foundation
import LocalAuthentication

enum CheckBiometricType {
  static func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
      let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch authContext.biometryType {
      case .touchID:
        return BiometricType.touch
      case .faceID:
        return BiometricType.face
      default:
        return BiometricType.none
      }
    } else {
      return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
    }
  }
}

enum BiometricType {
  case none
  case touch
  case face
}

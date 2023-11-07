//
//  DevOverrides.swift
//  Lunar
//
//  Created by Mani on 07/11/2023.
//

import Foundation

class devOverrides {
  var enableDebugger: Bool {
    if ProcessInfo.processInfo.environment["TEST_ENV_VA"] != nil {
      true
    } else {
      false
    }
  }
}

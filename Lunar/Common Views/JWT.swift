//
//  JWT.swift
//  Lunar
//
//  Created by Mani on 10/09/2023.
//

import Defaults
import Foundation
import SwiftUI

class JWT {
  @Default(.appBundleID) var appBundleID

  func getJWTFromKeychain(actorID: String) -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

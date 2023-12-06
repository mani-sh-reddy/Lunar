//
//  JWT.swift
//  Lunar
//
//  Created by Mani on 06/12/2023.
//

import Defaults
import Foundation
import SwiftUI

class JWT {
  @Default(.appBundleID) var appBundleID
  @Default(.activeAccount) var activeAccount

  func getJWTForActiveAccount() -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: activeAccount.actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }

  func getJWT(actorID: String) -> String? {
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

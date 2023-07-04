//
//  ValidationUtils.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation

enum ValidationUtils {
  static func isValidEmail(input: String) -> Bool {
    guard input.count >= 3 else { return false }
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let matched: Bool = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
    let isValid = matched
    return isValid
  }

  static func isValidUsername(input: String) -> Bool {
    guard input.count >= 3 else { return false }
    let regex = "[a-zA-Z0-9_]+"
    let matched = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
    let isValid = matched
    return isValid
  }

  static func isValidPassword(input: String) -> Bool {
    let isValid = 10 ... 60 ~= input.count
    return isValid
  }

  static func isValidTwoFactor(input: String) -> Bool {
    guard input.count == 6 else { return false }
    let twoFactorRegex = "^[0-9]{6}$"
    let twoFactorMatched = NSPredicate(format: "SELF MATCHES %@", twoFactorRegex).evaluate(
      with: input)
    return twoFactorMatched
  }
}

//
//  TextFieldLimiter.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Foundation

class TextFieldLimiter: ObservableObject {
  @Published var twoFactor = ""

  let characterLimit: Int

  init(limit: Int = 6) {
    characterLimit = limit
  }
}

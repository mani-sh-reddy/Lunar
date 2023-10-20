//
//  MailtoUtil.swift
//  Lunar
//
//  Created by Mani on 20/10/2023.
//

import Foundation
import SwiftUI

class Mailto {
  @Environment(\.openURL) var openURL

  func mailto(_ email: String) {
    let mailto = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    print(mailto ?? "")
    if let url = URL(string: mailto!) {
      openURL(url)
    }
  }
}

//
//  PrivateMessageObject.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Foundation
import SwiftUI

struct PrivateMessageObject: Codable {
  let privateMessage: PrivateMessage
  let creator, recipient: Person

  enum CodingKeys: String, CodingKey {
    case privateMessage = "private_message"
    case creator, recipient
  }
}

//
//  PrivateMessageModel.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Foundation
import SwiftUI

struct PrivateMessageModel: Codable {
  let privateMessages: [PrivateMessageObject]

  enum CodingKeys: String, CodingKey {
    case privateMessages = "private_messages"
  }
}

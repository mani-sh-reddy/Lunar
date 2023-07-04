//
//  Item.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date

  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}

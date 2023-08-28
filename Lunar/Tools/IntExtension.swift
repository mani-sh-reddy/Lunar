//
//  InsertSorter.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation

extension Int {
  func convertToShortString() -> String {
    let numberDouble = Double(self)
    
    if self >= 1_000_000 {
      return String(format: "%.1fM", numberDouble / 1_000_000)
    } else if self >= 1_000 {
      return String(format: "%.0fK", numberDouble / 1_000)
    } else {
      return String(self)
    }
  }
}

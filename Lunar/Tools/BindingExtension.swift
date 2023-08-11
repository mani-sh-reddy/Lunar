//
//  BindingExtension.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
  func max(_ limit: Int) -> Self {
    if wrappedValue.count > limit {
      DispatchQueue.main.async {
        self.wrappedValue = String(self.wrappedValue.dropLast())
      }
    }
    return self
  }
}

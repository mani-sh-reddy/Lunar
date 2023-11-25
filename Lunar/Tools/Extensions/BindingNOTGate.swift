//
//  BindingNOTGate.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Foundation
import SwiftUI

// periphery:ignore
extension Binding where Value == Bool {
  var not: Binding<Value> {
    Binding<Value>(
      get: { !self.wrappedValue },
      set: { self.wrappedValue = !$0 }
    )
  }
}

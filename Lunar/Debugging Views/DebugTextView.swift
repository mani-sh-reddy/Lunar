//
//  DebugTextView.swift
//  Lunar
//
//  Created by Mani on 26/10/2023.
//

import Foundation
import SwiftUI

struct DebugTextView: View {
  let name: String
  let value: String?

  var body: some View {
    HStack {
      Text("\(name): ")
        .bold()
        .font(.caption)
      if let value {
        Text(value)
          .font(.caption)
      }
    }
  }
}

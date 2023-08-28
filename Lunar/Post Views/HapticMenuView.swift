//
//  HapticMenuView.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//

import SwiftUI

struct HapticMenuView: View {
  @Binding var showingPlaceholderAlert: Bool

  var body: some View {
    Menu("Menu") {
      Button {
        showingPlaceholderAlert = true
      } label: {
        Text("Coming Soon")
      }
    }
    Button {
      showingPlaceholderAlert = true
    } label: {
      Text("Coming Soon")
    }

    Divider()

    Button(role: .destructive) {
      showingPlaceholderAlert = true
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }
}

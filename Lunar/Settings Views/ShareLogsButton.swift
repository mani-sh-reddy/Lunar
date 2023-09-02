//
//  ShareLogsButton.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import SwiftUI

struct ShareLogsButton: View {
  @AppStorage("logs") var logs = Settings.logs
  @State private var isPresentingShareSheet = false

  var body: some View {
    Button {
      isPresentingShareSheet = true

    } label: {
      Label {
        Text("Share Logs")
          .foregroundStyle(.foreground)
      } icon: {
        Image(systemName: "square.and.arrow.up")
          .foregroundStyle(.blue)
      }
    }
    .shareSheet(isPresented: $isPresentingShareSheet, items: ["\(String(describing: logs))"])
  }
}

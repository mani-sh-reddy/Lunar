//
//  ClearLogsButton.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import SwiftUI

struct ClearLogsButton: View {
  @AppStorage("logs") var logs = Settings.logs
  
  let haptic = UINotificationFeedbackGenerator()
  
  @State var showingConfirmation: Bool = false
  
  var body: some View {
    Button {
      showingConfirmation = true
    } label: {
      Label {
        Text("Erase Logs")
          .foregroundStyle(.foreground)
      } icon: {
        Image(systemName: "eraser.line.dashed")
          .foregroundStyle(.red)
      }
    }
    .confirmationDialog("Are you sure?",
                        isPresented: $showingConfirmation) {
      Button("Delete all items?", role: .destructive) {
        haptic.notificationOccurred(.success)
        logs = []
      }
    } message: {
      Text("You cannot undo this action")
    }
  }
}

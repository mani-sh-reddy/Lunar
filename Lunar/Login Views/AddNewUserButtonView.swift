//
//  AddNewUserButtonView.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import SwiftUI

struct AddNewUserButtonView: View {
  @Binding var showingPopover: Bool
  var body: some View {
    Button(action: addNewUserButtonAction) {
      Label {
        Text("Add User").foregroundStyle(.blue)
      } icon: {
        Image(systemName: "plus.circle.fill")
          .font(.title2)
          .foregroundStyle(.blue)
          .symbolRenderingMode(.hierarchical)
      }
    }
  }

  private func addNewUserButtonAction() {
    withAnimation(.linear(duration: 1)) {
      showingPopover = true
    }
  }
}

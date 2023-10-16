//
//  DebugSettingsPropertiesView.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import Defaults
import SwiftUI

struct DebugSettingsPropertiesView: View {
  @Default(.activeAccount) var activeAccount

  var body: some View {
    Section {
      VStack(alignment: .leading) {
        Text("Debug Properties").bold().textCase(.uppercase)
        VStack(alignment: .leading) {
          Text("activeAccount: ").bold()
          Text("\(String(describing: activeAccount))")
        }
      }
    }
    .font(.caption)
//    .if(!debugModeEnabled) { _ in EmptyView() }
  }
}

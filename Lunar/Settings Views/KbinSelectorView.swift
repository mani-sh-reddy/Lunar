//
//  KbinSelectorView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import Defaults
import Foundation
import SwiftUI

struct KbinSelectorView: View {
  @Default(.kbinActive) var kbinActive
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

  var body: some View {
    Toggle("Enable Kbin", isOn: $kbinActive)
      .tint(accentColorString == "Default" ? .purple : accentColor)
  }
}

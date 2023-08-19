//
//  KbinSelectorView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import Foundation
import SwiftUI

struct KbinSelectorView: View {
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive

  var body: some View {
    Toggle("Enable Kbin", isOn: $kbinActive).tint(.purple)
  }
}

//
//  SettingsAppIconPickerView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Defaults
import Foundation
import SwiftUI

struct SettingsAppIconPickerView: View {
  @Default(.selectedAppIcon) var selectedAppIcon

  private var appIcons = [
    ("Default", "Default"),
    ("Space", "Space"),
    ("Lemming", "Lemming"),
    ("Original", "v0"),
    ("Night", "Night"),
    ("Purple", "Purple"),
    ("Kbin", "Kbin")
  ]

  var body: some View {
    List {
      Picker("Icons", selection: $selectedAppIcon) {
        ForEach(appIcons, id: \.1.self) { name, identifier in
          Label {
            Text(name)
              .padding(.horizontal, 10)
          } icon: {
            Image("AppIconDownsized\(identifier)")
              .resizable()
              .frame(width: 50, height: 50)
              .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
          }
          .tag("AppIcon\(identifier)")
          .padding(.horizontal, 10)
        }
      }
      .pickerStyle(.inline)
    }
    .onChange(of: selectedAppIcon) { newValue in
      if newValue == "AppIconDefault" {
        UIApplication.shared.setAlternateIconName(nil)
      } else {
        UIApplication.shared.setAlternateIconName(newValue)
      }
    }
    .navigationTitle("App Icons")
  }
}

#Preview {
  SettingsAppIconPickerView()
}

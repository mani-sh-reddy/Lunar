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
    ("New", "Light"),
    ("Original", "v0"),
    ("Dark", "Dark"),
    ("Purple", "Purple"),
    ("Night", "Night"),
    ("Lemmy Y", "LemmY"),
    ("Kbin", "Kbin"),
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
      if newValue == "AppIconLight" {
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

//
//  SettingsAppIconPickerView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Foundation
import SwiftUI

struct SettingsAppIconPickerView: View {
  @AppStorage("selectedAppIcon") var selectedAppIcon = Settings.selectedAppIcon
  //
  private var appIconNames = [
    /// **Prepended with 'AppIcon'**
    "Light", "Dark", "Purple", "Night", "LemmY", "Kbin",
  ]

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    List {
      ForEach(appIconNames, id: \.self) { iconName in
        Button {
          selectedAppIcon = "AppIcon\(iconName)"
          if selectedAppIcon == "AppIconLight" {
            UIApplication.shared.setAlternateIconName(nil)
          } else {
            UIApplication.shared.setAlternateIconName(selectedAppIcon)
          }
          haptics.impactOccurred(intensity: 0.5)
        } label: {
          HStack {
            Image("AppIconDownsized\(iconName)")
              .resizable()
              .frame(width: 50, height: 50)
              .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
              .padding(.trailing, 10)
            Text(iconName).tag("AppIcon\(iconName)")
            Spacer()
            Image(
              systemName: selectedAppIcon == "AppIcon\(iconName)"
                ? "checkmark.circle.fill" : "circle"
            )
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(.indigo)
          }
        }
      }.foregroundStyle(.foreground)
    }
    .navigationTitle("App Icons")
  }
}

struct SettingsAppIconPickerView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsAppIconPickerView()
  }
}

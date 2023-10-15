//
//  SettingsThemeView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Defaults
import Shiny
import SwiftUI

struct SettingsThemeView: View {
  @AppStorage("appAppearance") var appAppearance: AppearanceOptions = .system
  @Default(.iridescenceEnabled) var iridescenceEnabled

  var body: some View {
    List {
      Section {
        Picker("Appearance", selection: $appAppearance) {
          ForEach(AppearanceOptions.allCases, id: \.self) { option in
            Text(option.rawValue.capitalized)
          }
        }
        .pickerStyle(.menu)
        .onChange(of: appAppearance) { _ in
          AppearanceController.shared.setAppearance()
        }
      }
      Section {
        Toggle(isOn: $iridescenceEnabled) {
          Text("Iridescent Effects")
        }
        .tint(.indigo)
      }
      .modifier(ConditionalListRowBackgroundModifier(background: iridescenceEnabled ? .iridescent : .defaultBackground))
    }
    .navigationTitle("Theme")
  }
}

struct SettingsThemeView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsThemeView()
  }
}

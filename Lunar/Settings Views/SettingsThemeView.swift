//
//  SettingsThemeView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

struct SettingsThemeView: View {
  @AppStorage("appAppearance") var appAppearance: AppearanceOptions = .system
  
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
    }
    .navigationTitle("Theme")
  }
}
  
struct SettingsThemeView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsThemeView()
  }
}

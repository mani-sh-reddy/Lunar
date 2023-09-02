//
//  SettingsAppearanceSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsAppearanceSectionView: View {
  var body: some View {
    Section {
      NavigationLink {
        SettingsAppIconPickerView()
      } label: {
        Label {
          Text("App Icon")
        } icon: {
          Image(systemName: "app.dashed")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.gray)
        }
      }

      NavigationLink {
        SettingsThemeView()
      } label: {
        Label {
          Text("Theme")
        } icon: {
          Image(systemName: "paintbrush")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.indigo)
        }
      }

      NavigationLink {
        SettingsLayoutView()
      } label: {
        Label {
          Text("Layout")
        } icon: {
          Image(systemName: "square.on.square.squareshape.controlhandles")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.mint)
        }
      }

      NavigationLink {
        SettingsSplashScreenView()
      } label: {
        Label {
          Text("Splash Screen")
        } icon: {
          Image(systemName: "moonphase.waning.gibbous")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.yellow)
        }
      }

    } header: {
      Text("Appearance")
    }
  }
}

struct SettingsAppearanceSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsAppearanceSectionView()
  }
}

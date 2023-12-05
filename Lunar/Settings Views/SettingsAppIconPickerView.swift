//
//  SettingsAppIconPickerView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import Collections
import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct SettingsAppIconPickerView: View {
  @Default(.selectedAppIcon) var selectedAppIcon

  let notificationHaptics = UINotificationFeedbackGenerator()

  private var appIcons: OrderedDictionary<String, [(String, String, String)]> {
    return [
      "Default": [
        ("Default", "Default", "")
      ],
      "Community Icons": [
        ("@MrSebSin", "MrSebSin", "https://lemmy.world/u/MrSebSin")
      ],
      "Created by Mani": [
        ("Lemming", "Lemming", ""),
        ("Kbin", "Kbin", ""),
        ("Space", "Space", "")
      ],
      "Colors": [
        ("Blue", "v0", ""),
        ("Black", "Night", ""),
        ("Purple", "Purple", "")
      ]
    ]
  }

  var body: some View {
    List {
      ForEach(appIcons.elements, id: \.key) { heading, value in
        Section {
          Picker("Icons", selection: $selectedAppIcon) {
            ForEach(value, id: \.1) { name, identifier, link in
              AppIconRow(name: name, identifier: identifier, link: link)
            }
          }
          .labelsHidden()
          .pickerStyle(.inline)
        } header: {
          Text(heading)
        }
      }
    }
    .onChange(of: selectedAppIcon) { newValue in
      if newValue == "AppIconDefault" {
        UIApplication.shared.setAlternateIconName(nil)
      } else {
        UIApplication.shared.setAlternateIconName(newValue)
      }
      notificationHaptics.notificationOccurred(.success)
    }
    .navigationTitle("App Icons")
  }
}

struct AppIconRow: View {
  var name: String
  var identifier: String
  var link: String

  let defaultURL: String = "https://lemmy.world"

  @State private var showSafari = false

  var body: some View {
    Label {
      HStack(alignment: .center) {
        if !link.isEmpty {
          Button {
            showSafari = true
          } label: {
            Text(name)
          }
        } else {
          Text(name)
        }
      }
      .padding(.horizontal, 10)
    } icon: {
      Image("AppIconScale\(identifier)")
        .resizable()
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    .tag("AppIcon\(identifier)")
    .padding(.horizontal, 10)
    .inAppSafari(
      isPresented: $showSafari,
      stringURL: link
    )
  }
}

#Preview {
  SettingsAppIconPickerView()
}

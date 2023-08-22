//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct InstanceSelectorView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @State private var isCustomSelected = false
  @State private var customInstanceName = ""
  @State private var tempInstanceName = ""
  
  var body: some View {
    if debugModeEnabled {
      Text("instance: \(instanceHostURL)")
        .bold()
        .foregroundStyle(.cyan)
    }
    
    Section {
      Picker(selection: $tempInstanceName, label: Text("Lemmy Instance")) {
        Text("lemmy.world").tag("lemmy.world")
        Text("lemmy.ml").tag("lemmy.ml")
        Text("beehaw.org").tag("beehaw.org")
        Text("programming.dev").tag("programming.dev")
        Divider()
          Text("Custom").tag("custom")
      }
      .pickerStyle(.menu)
      
      
      .onChange(of: tempInstanceName) { name in
        if name == "custom" {
          isCustomSelected = true
          instanceHostURL = "lemmy.world"
          customInstanceName = ""
        } else {
          isCustomSelected = false
          instanceHostURL = name
        }
      }
      
      if isCustomSelected {
        HStack {
          Text("Custom:")
            .multilineTextAlignment(.leading)
          TextField("Custom", text: $customInstanceName, prompt: Text("lemmy.world"))
            .multilineTextAlignment(.trailing)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .keyboardType(.URL)
            .onSubmit {
              instanceHostURL = customInstanceName
              // Dismiss Keyboard
            }
        }
      }
    }
    .onAppear {
      tempInstanceName = instanceHostURL
    }
  }
}


struct SettingsServerSelectionSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

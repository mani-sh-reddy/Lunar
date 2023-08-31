//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI
import Alamofire

struct InstanceSelectorView: View {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("lemmyInstances") var lemmyInstances = Settings.lemmyInstances
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("logs") var logs = Settings.logs
  
  @State var showingAlreadyExistsError = false
  @State var showingInvalidInstanceError = false
  @State var customInstance = ""
  @State var enteredCustomInstance = ""
  @State var instanceOnAppear = "lemmy.world"
  
  var body: some View {
    if debugModeEnabled {
      Text("deselected: \(selectedInstance)")
    }
    
    
    Section {
      if lemmyInstances.isEmpty{
        Text("Add instances to get started!")
          .foregroundStyle(.orange)
      } else {
        Picker(selection: $selectedInstance, label: Text("Instance")) {
          ForEach(lemmyInstances, id: \.self) { instance in
            Text(instance).tag(instance)
          }
        }
        .pickerStyle(.menu)
      }
      
    }
  }
}

struct SettingsServerSelectionSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Alamofire
import Defaults
import SwiftUI

struct InstanceSelectorView: View {
  @Default(.selectedInstance) var selectedInstance
  @Default(.lemmyInstances) var lemmyInstances
  @Default(.debugModeEnabled) var debugModeEnabled

  var body: some View {
    if debugModeEnabled {
      Text("selected instance: \(selectedInstance)")
    }

    Section {
      if lemmyInstances.isEmpty {
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

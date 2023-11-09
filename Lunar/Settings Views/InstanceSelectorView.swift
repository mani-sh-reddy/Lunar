//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import RealmSwift
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
    .onChange(of: selectedInstance) { _ in
      resetRealmPosts()
    }
  }

  func resetRealmPosts() {
    let realm = try! Realm()
    try! realm.write {
      let posts = realm.objects(RealmPost.self)
      realm.delete(posts)
    }
  }
}

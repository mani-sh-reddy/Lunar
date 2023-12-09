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
  @Default(.activeAccount) var activeAccount
  @Default(.lemmyInstances) var lemmyInstances
  @Default(.debugModeEnabled) var debugModeEnabled
  
  let haptics = UIImpactFeedbackGenerator(style: .soft)
  
  @State var showWarningReasonAlert = false

  var body: some View {
    if debugModeEnabled {
      Text("selected instance: \(selectedInstance)")
    }

    Section {
      if lemmyInstances.isEmpty {
        Text("Add instances to get started!")
          .foregroundStyle(.orange)
      } else {
        Picker(selection: $selectedInstance, label: pickerLabel) {
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
  
  var pickerLabel: some View {
    HStack {
      Text("Instance")
      if !activeAccount.instance.isEmpty, activeAccount.instance != selectedInstance {
        Image(systemSymbol: .exclamationmarkTriangle)
          .symbolRenderingMode(.multicolor)
          .onTapGesture {
            showWarningReasonAlert = true
            haptics.impactOccurred(intensity: 0.5)
          }
          .alert("Selected instance does not match currently-active user's instance. Some actions may fail.", isPresented: $showWarningReasonAlert) {
            Button(role: .cancel) {
              showWarningReasonAlert = false
            } label: {
              Text("Dismiss")
            }
          }
      }
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

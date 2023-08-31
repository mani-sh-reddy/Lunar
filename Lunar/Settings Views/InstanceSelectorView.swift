//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Alamofire
import SwiftUI

struct InstanceSelectorView: View {
  // TODO: - #183 Temporarily removed custom instances and added more instances to list
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("lemmyInstances") var lemmyInstances = Settings.lemmyInstances
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("logs") var logs = Settings.logs

  //  let topInstances: [String] = [
  //    "lemmy.world",
  //    "lemmy.ml",
  //    "beehaw.org",
  //    "programming.dev",
  //    "lemm.ee",
  //    "reddthat.com",
  //  ]
  //
  //  let moreIinstances: [String] = [
  //    "discuss.online",
  //    "discuss.tchncs.de",
  //    "feddit.de",
  //    "feddit.it",
  //    "feddit.uk",
  //    "hexbear.net",
  //    "infosec.pub",
  //    "lemmy.blahaj.zone",
  //    "lemmy.ca",
  //    "lemmy.dbzer0.com",
  //    "lemmy.one",
  //    "lemmy.sdf.org",
  //    "lemmy.zip",
  //    "sh.itjust.works",
  //    "slrpnk.net",
  //    "sopuli.xyz",
  //    "startrek.website",
  //    "ttrpg.network",
  //  ]

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
      if lemmyInstances.isEmpty {
        Text("Add instances to get started!")
          .foregroundStyle(.orange)
      } else {
        Picker(selection: $selectedInstance, label: Text("Selected Instance")) {
          ForEach(lemmyInstances, id: \.self) { instance in
            Text(instance).tag(instance)
          }
        }
        .pickerStyle(.menu)
      }

    }
    NavigationLink {
      ManageInstancesView()
    } label: {
      Text("Manage Instances")
    }
  }
}

struct SettingsServerSelectionSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

//
//  InstanceSelectorView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct InstanceSelectorView: View {
  // TODO: - #183 Temporarily removed custom instances and added more instances to list
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  
  let topInstances: [String] = [
    "lemmy.world",
    "lemmy.ml",
    "beehaw.org",
    "programming.dev",
    "lemm.ee",
    "reddthat.com"
  ]
  
  let moreIinstances: [String] = [
    "discuss.online",
    "discuss.tchncs.de",
    "feddit.de",
    "feddit.it",
    "feddit.uk",
    "hexbear.net",
    "infosec.pub",
    "lemmy.blahaj.zone",
    "lemmy.ca",
    "lemmy.dbzer0.com",
    "lemmy.one",
    "lemmy.sdf.org",
    "lemmy.zip",
    "sh.itjust.works",
    "slrpnk.net",
    "sopuli.xyz",
    "startrek.website",
    "ttrpg.network"
  ]
  
  var body: some View {
    if debugModeEnabled {
      Text("instance: \(instanceHostURL)")
        .bold()
        .foregroundStyle(.cyan)
    }
    
    Section {
      Picker(selection: $instanceHostURL, label: Text("Lemmy Instance")) {
        ForEach(topInstances, id: \.self) { instance in
          Text(instance).tag(instance)
        }
        Divider()
        ForEach(moreIinstances, id: \.self) { instance in
          Text(instance).tag(instance)
        }
      }
      .pickerStyle(.menu)
    }
  }
}


struct SettingsServerSelectionSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

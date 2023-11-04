////
////  SettingsFeedView.swift
////  Lunar
////
////  Created by Mani on 08/09/2023.
////
//
// import Defaults
// import Foundation
// import SwiftUI
//
// struct SettingsFeedView: View {
//  @Default(.autoCollapseBots) var autoCollapseBots
//  @Default(.enableQuicklinks) var enableQuicklinks
//
//  var body: some View {
//    List {
//      Section {
//        Toggle(isOn: $enableQuicklinks) {
//          Text("Enable Quicklinks")
//        }
//      } header: {
//        Text("Quicklinks")
//      }
//      footer: {
//        Text("With QuickLinks off, you'll only see Local and Federated links. Use the picker in the toolbar to sort posts.")
//      }
//
//      Section {
//        Toggle(isOn: $autoCollapseBots) {
//          Text("Auto-collapse Bots")
//        }
//      } header: {
//        Text("Comments")
//      }
//    }
//    .navigationTitle("Feed Options")
//  }
// }
//
// struct SettingsFeedView_Previews: PreviewProvider {
//  static var previews: some View {
//    SettingsFeedView()
//  }
// }

//
//  SettingsClearRealmView.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Defaults
import Nuke
import RealmSwift
import SFSafeSymbols
import SwiftUI
import UIKit

struct SettingsClearRealmView: View {
  @Default(.appBundleID) var appBundleID
  @Default(.realmLastReset) var realmLastReset
  @Default(.activeAccount) var activeAccount

  @State var lastReset: String = ""

  @State var alertPresented: Bool = false
  let haptics = UINotificationFeedbackGenerator()

  var body: some View {
    Label {
      Text("Last Reset: \(realmLastReset)")
    } icon: {
      Image(systemSymbol: .clockArrow2Circlepath)
        .symbolRenderingMode(.palette)
        .foregroundStyle(.red, .gray)
    }
    Button {
      alertPresented = true
    } label: {
      Label {
        Text("Reset Database")
          .foregroundStyle(.foreground)
      } icon: {
        Image(systemSymbol: .squareStack3dUpSlash)
          .foregroundStyle(.red, .gray)
          .symbolRenderingMode(.palette)
      }
    }
    .alert("Reset Database", isPresented: $alertPresented) {
      Button("Reset", role: .destructive) {
        clearCache()
        realmLastReset = currentDateAndTime()
      }
    }
  }

  func clearCache() {
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
    haptics.notificationOccurred(.success)

    if !activeAccount.actorID.isEmpty {
      refetchSubscribedCommunities()
    }
  }

  func refetchSubscribedCommunities() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      CommunitiesFetcher(
        limitParameter: 50,
        sortParameter: "Active",
        typeParameter: "Subscribed",
        instance: URLParser.extractDomain(from: activeAccount.actorID)
      ).loadContent()
    }
  }

  func currentDateAndTime() -> String {
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma d MMM yy"
    let dateString = formatter.string(from: currentDate)
    return dateString
  }
}

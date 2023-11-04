//
//  AppDelegate.swift
//  Lunar
//
//  Created by Mani on 17/09/2023.
//

import Defaults
import Foundation
import LocalConsole
import Nuke
import RealmSwift
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
  @Default(.appBundleID) var appBundleID

  var dataCacheHolder: DataCacheHolder?

  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    print("App Started")
    initialiseLocalConsole()
    initialiseNukeUI()
    initialiseRealm()
    return true
  }

  func initialiseLocalConsole() {
    _ = LCManager.shared
  }

  func initialiseNukeUI() {
    DataLoader.sharedUrlCache.diskCapacity = 0

    let pipeline = ImagePipeline {
      self.dataCacheHolder = DataCacheHolder(appBundleID: self.appBundleID)
      $0.dataCache = self.dataCacheHolder?.dataCache
      $0.dataCachePolicy = .storeAll
      $0.isProgressiveDecodingEnabled = true
    }

    ImagePipeline.shared = pipeline
  }

  func initialiseRealm() {
    print("Realm DB Path:")
    print("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)")

    let config = Realm.Configuration(
      schemaVersion: 3,
      migrationBlock: { _, oldSchemaVersion in
        if oldSchemaVersion < 1 {}
      },
      deleteRealmIfMigrationNeeded: true
    )
    Realm.Configuration.defaultConfiguration = config
  }
}

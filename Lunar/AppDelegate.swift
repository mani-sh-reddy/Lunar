//
//  AppDelegate.swift
//  Lunar
//
//  Created by Mani on 17/09/2023.
//

import Foundation
import Nuke
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

  var dataCacheHolder: DataCacheHolder?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    print("App Started")

    DataLoader.sharedUrlCache.diskCapacity = 0

    let pipeline = ImagePipeline {
      self.dataCacheHolder = DataCacheHolder(appBundleID: self.appBundleID)
//      let dataCache = try? DataCache(name: "\(self.appBundleID)")
//
//      dataCache?.sizeLimit = 4000 * 1024 * 1024

//      $0.dataCache = dataCache
//      $0.dataCachePolicy = .storeAll
      $0.dataCache = self.dataCacheHolder?.dataCache
      $0.dataCachePolicy = .storeAll
    }

    ImagePipeline.shared = pipeline

    return true
  }
}

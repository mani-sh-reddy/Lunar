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

class AppDelegateM: UIResponder, UIApplicationDelegate {
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
    PhaseChangeActions().homeScreenQuickActions()
    listPostsMoya(parameters: ListPostsParameters(type: "All", sort: "Active"))
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
  
  func listPostsMoya(parameters: ListPostsParameters = ListPostsParameters()) {
    lemmyProvider.request(.listPosts(parameters: parameters)) { result in
      switch result {
      case let .success(response):
        do {
          let decoder = JSONDecoder()
          let postsModel = try decoder.decode(PostModel.self, from: response.data)
          
          print(postsModel.posts[0].post.name)
          print(postsModel.posts[1].post.name)
          print(postsModel.posts[2].post.name)
          
        } catch {
          print("Error decoding posts: \(error)")
        }
        
      case let .failure(error):
        print("Network request failed: \(error)")
      }
    }
  }
}

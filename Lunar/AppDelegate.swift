//
//  AppDelegate.swift
//  Lunar
//
//  Created by Mani on 17/09/2023.
//

import Foundation
import SwiftUI
import Nuke

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("App Started")
    
    // 1 Disable URL cache
    DataLoader.sharedUrlCache.diskCapacity = 0
    
    let pipeline = ImagePipeline {
      // 2
      let dataCache = try? DataCache(name: "io.github.mani-sh-reddy.Lunar")
      
      // 3
      dataCache?.sizeLimit = 4000 * 1024 * 1024
      
      // 4
      $0.dataCache = dataCache
      $0.dataCachePolicy = .storeAll
    }
    
    // 5
    ImagePipeline.shared = pipeline
    
    return true
  }
}

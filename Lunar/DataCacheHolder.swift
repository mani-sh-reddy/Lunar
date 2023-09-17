//
//  DataCacheHolder.swift
//  Lunar
//
//  Created by Mani on 17/09/2023.
//

import Foundation
import Nuke

class DataCacheHolder: ObservableObject {
  @Published var dataCache: DataCache?
  
  init(appBundleID: String) {
    self.dataCache = try? DataCache(name: appBundleID)
    self.dataCache?.sizeLimit = 4000 * 1024 * 1024
  }
}

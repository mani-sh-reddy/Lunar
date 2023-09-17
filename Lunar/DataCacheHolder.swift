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
    dataCache = try? DataCache(name: appBundleID)
    dataCache?.sizeLimit = 4000 * 1024 * 1024
  }
}

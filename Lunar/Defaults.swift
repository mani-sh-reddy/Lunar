//
//  Defaults.swift
//  Lunar
//
//  Created by Mani on 190/08/2023.
//

import Foundation
import SwiftUI
import Defaults

extension Defaults.Keys {
  static let postSortType = Key<SortType>("postsSortType", default: .active)
  static let searchSortType = Key<SortType>("searchSortType", default: .topYear)
}

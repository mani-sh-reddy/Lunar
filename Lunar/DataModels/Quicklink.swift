//
//  Quicklink.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Defaults
import Foundation
import SwiftUI

struct Quicklink: Codable, Hashable, Defaults.Serializable {
  var title: String = ""
  var type: String = ""
  var sort: String = ""
  var icon: String = ""
  var iconColor: String = ""
  var brightness: Double = 0.3
  var saturation: Double = 2
}

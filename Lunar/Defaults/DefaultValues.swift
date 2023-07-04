//
//  DefaultValues.swift
//  Lunar
//
//  Created by Mani on 190/08/2023.
//

import Defaults
import Foundation
import SwiftUI

enum DefaultValues {
  static let lemmyInstances = [
    "lemmy.world",
    "lemmy.ml",
    "beehaw.org",
    "programming.dev",
    "lemm.ee",
  ]
  static let appBundleID = Bundle.main.bundleIdentifier ?? "io.github.mani-sh-reddy.Lunar.app"
}

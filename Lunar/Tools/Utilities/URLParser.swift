//
//  URLParser.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

enum URLParser {
  /// "https://lemmy.world/u/mani" ==> _lemmy.world_
  static func extractDomain(from url: String) -> String {
    guard let urlComponents = URLComponents(string: url),
          let host = urlComponents.host
    else {
      return ""
    }

    if let range = host.range(
      of: #"^(www\.)?([a-zA-Z0-9-]+\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?$"#,
      options: .regularExpression
    ) {
      return String(host[range])
    }

    return ""
  }

  static func extractPath(from url: String) -> String {
    guard let urlComponents = URLComponents(string: url) else {
      return ""
    }

    let path = urlComponents.path

    return path
  }

  /// "https://lemmy.world/u/mani" ==> _mani_
  static func extractUsername(from url: String) -> String {
    let path = extractPath(from: url)
    if let range = path.range(of: "/u/", options: .regularExpression) {
      return String(path[range.upperBound...])
    }
    return ""
  }

  /// https://lemmy.world/other_information ==> _lemmy_
  static func extractBaseDomain(from url: String) -> String {
    let domain = extractDomain(from: url)

    let components = domain.components(separatedBy: ".")

    return components.penultimate() ?? ""
  }

  /// "https://lemmy.world/u/mani" ==> _mani@lemmy.world_
  static func buildFullUsername(from url: String) -> String {
    "\(extractUsername(from: url))@\(extractDomain(from: url))"
  }

  /// "https://lemmy.world/c/asklemmy" ==> _asklemmy@lemmy.world_
  static func buildFullCommunity(from communityActorID: String) -> String {
    "\(extractUsername(from: communityActorID))@\(extractDomain(from: communityActorID))"
  }
}

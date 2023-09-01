//
//  CommunityModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct CommunityModel: Codable {
  let communities: [CommunityObject]
  
  var iconURLs: [String] {
    communities.compactMap(\.community.icon)
  }
}

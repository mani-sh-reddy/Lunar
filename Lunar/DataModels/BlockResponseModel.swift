//
//  BlockResponseModel.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Foundation

struct BlockResponseModel: Codable {
  let person: PersonObject?
  let community: CommunityObject?
  let blocked: Bool

  enum CodingKeys: String, CodingKey {
    case person = "person_view"
    case community = "community_view"
    case blocked
  }
}

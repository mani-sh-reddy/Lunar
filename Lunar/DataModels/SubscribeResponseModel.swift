//
//  SubscribeResponseModel.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//

import Foundation

struct SubscribeResponseModel: Codable {
  let community: CommunityElement?

  enum CodingKeys: String, CodingKey {
    case community = "community_view"
  }
}

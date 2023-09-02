//
//  CommunityObject.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct CommunityObject: Codable {
  let community: Community
  let subscribed: SubscribedState
  let counts: Counts

  let blocked: Bool
}

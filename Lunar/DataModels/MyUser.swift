//
//  MyUser.swift
//  Lunar
//
//  Created by Mani on 01/09/2023.
//

import Foundation

struct MyUser: Codable {
  let localUserView: LocalUser
  let follows: [JSONAny]?
  let moderates: [JSONAny]?
  let communityBlocks: [JSONAny]?
  let personBlocks: [JSONAny]?
  let discussionLanguages: [JSONAny]?

  enum CodingKeys: String, CodingKey {
    case localUserView = "local_user_view"
    case follows
    case moderates
    case communityBlocks = "community_blocks"
    case personBlocks = "person_blocks"
    case discussionLanguages = "discussion_languages"
  }
}

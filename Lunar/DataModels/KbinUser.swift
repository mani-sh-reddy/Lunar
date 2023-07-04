//
//  KbinUser.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

struct KbinUser: Codable {
  let userID: Int
  let username: String?
  let isBot, isFollowedByUser, isFollowerOfUser, isBlockedByUser: Bool?
  let avatar: KbinImage?
  let apID: String?
  let apProfileID: String?
  let createdAt: String?

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case username, isBot, isFollowedByUser, isFollowerOfUser, isBlockedByUser, avatar
    case apID = "apId"
    case apProfileID = "apProfileId"
    case createdAt
  }
}

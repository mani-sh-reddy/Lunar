//
//  KbinPostObject.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

struct KbinPostObject: Codable {
  let postID: Int
  let user: KbinUser?
  let magazine: KbinMagazine?
  let image: KbinImage?
  let body, lang: String?
  let isAdult, isPinned: Bool?
  let slug: String?
  let comments, uv, dv, favourites: Int?
  let isFavourited: Bool?
  let userVote: Int?
  let tags, mentions: [String]?
  let apID, createdAt, editedAt, lastActive: String?
  let visibility: String?

  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case user, magazine, image, body, lang, isAdult, isPinned, slug, comments, uv, dv, favourites, isFavourited, userVote, tags, mentions
    case apID = "apId"
    case createdAt, editedAt, lastActive, visibility
  }
}

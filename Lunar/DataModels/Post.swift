//
//  Post.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct Post: Codable {
  let name: String
  let published: String
  let apID: String

  let url: String?
  let body: String?
  let updated: String?
  let embedTitle: String?
  let embedVideoURL: String?
  let thumbnailURL: String?
  let embedDescription: String?

  let id: Int
  let languageID: Int
  let creatorID: Int
  let communityID: Int

  let removed: Bool
  let locked: Bool
  let deleted: Bool
  let local: Bool
  let featuredCommunity: Bool
  let featuredLocal: Bool

  let nsfw: Bool = false

  enum CodingKeys: String, CodingKey {
    case id, name, url
    case creatorID = "creator_id"
    case communityID = "community_id"
    case removed, locked, published, deleted, nsfw
    case thumbnailURL = "thumbnail_url"
    case apID = "ap_id"
    case local
    case languageID = "language_id"
    case featuredCommunity = "featured_community"
    case featuredLocal = "featured_local"
    case body, updated
    case embedTitle = "embed_title"
    case embedDescription = "embed_description"
    case embedVideoURL = "embed_video_url"
  }
}

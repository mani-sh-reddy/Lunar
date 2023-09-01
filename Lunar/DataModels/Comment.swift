//
//  Comment.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct Comment: Codable {
  let content: String
  let published: String
  let apID: String
  let path: String
  
  let id: Int
  let creatorID: Int
  let postID: Int
  let languageID: Int
  
  let removed: Bool
  let deleted: Bool
  let local: Bool
  let distinguished: Bool
  
  let updated: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case postID = "post_id"
    case content
    case removed
    case published
    case deleted
    case updated
    case apID = "ap_id"
    case local
    case path
    case distinguished
    case languageID = "language_id"
  }
}

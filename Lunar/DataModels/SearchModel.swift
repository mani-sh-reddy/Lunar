//
//  SearchModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

struct SearchModel: Codable {
  let comments: [CommentObject]
  let posts: [PostObject]
  let communities: [CommunityObject]
  let users: [PersonObject]

  let type: String

  enum CodingKeys: String, CodingKey {
    case type = "type_"
    case comments
    case posts
    case communities
    case users
  }
}

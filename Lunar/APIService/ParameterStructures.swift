//
//  DataStructs.swift
//  Lunar
//
//  Created by Mani on 05/12/2023.
//

import Foundation

struct ListPostsParameters {
  var type: String?
  var sort: String?
  var page: Int?
  var limit: Int?
  var communityId: Int?
  var communityName: String?
  var savedOnly: Bool?
  var likedOnly: Bool?
  var dislikedOnly: Bool?
  var pageCursor: String?
}

struct CreatePostParameters {
  var name: String
  var communityId: Int
  var url: String?
  var body: String?
  var honeypot: String?
  var nsfw: Bool?
  var languageId: Int
  var auth: String
}

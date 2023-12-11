//
//  LegacyKbinThreadsModel.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Foundation

struct LegacyKbinPost {
  var id: String
  var title: String
  var user: String
  var timeAgo: String
  var upvotes: Int
  var downvotes: Int
  var previewImageUrl: String
  var commentsCount: Int
  var imageUrl: String
  var magazine: String
  var userObject: LegacyKbinUser?
  var instanceLink: String?
  var postURL: String
}

struct LegacyKbinUser {
  var username: String
  var avatarUrl: String
  var joined: String
  var reputationPoints: Int
  var browseUrl: String
  var followCount: Int
}

struct LegacyKbinComment {
  let id: String
  let indentLevel: String
  let author: String
  let date: String
  let content: String
  var replies: [LegacyKbinComment]
}

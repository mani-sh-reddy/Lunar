//
//  KbinThreadsModel.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Foundation

struct KbinPost {
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
  var userObject: KbinUser?
  var instanceLink: String?
  var postURL: String
}

struct KbinUser {
  var username: String
  var avatarUrl: String
  var joined: String
  var reputationPoints: Int
  var browseUrl: String
  var followCount: Int
}

struct KbinWebPage {
  var posts: [KbinPost]
}

struct KbinComment {
  let id: String
  let indentLevel: String
  let author: String
  let date: String
  let content: String
  var replies: [KbinComment]
}

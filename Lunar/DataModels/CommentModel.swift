//
//  CommentsModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

// MARK: - CommentModel

struct CommentModel: Codable {
  let comments: [CommentElement]
}

// MARK: - CommentElement

struct CommentElement: Codable {
  let comment: CommentsListObject
  let creator: CommentsListCreator
  let post: PostObject
  let community: CommentsListCommunity
  let counts: CommentsListCounts
  let creatorBannedFromCommunity: Bool
  let subscribed: CommentSubscribed?
  let saved, creatorBlocked: Bool
  var myVote: Int?

  enum CodingKeys: String, CodingKey {
    case comment, creator, post, community, counts
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case subscribed, saved
    case creatorBlocked = "creator_blocked"
    case myVote = "my_vote"
  }
}

// MARK: - CommentsListObject

struct CommentsListObject: Codable {
  let id, creatorID, postID: Int
  let content: String
  let removed: Bool
  let published: String
  let deleted: Bool
  let apID: String
  let local: Bool
  let path: String
  let distinguished: Bool
  let languageID: Int

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case postID = "post_id"
    case content, removed, published, deleted
    case apID = "ap_id"
    case local, path, distinguished
    case languageID = "language_id"
  }
}

// MARK: - CommentsListCommunity

struct CommentsListCommunity: Codable {
  let id: Int
  let name: String
  let title: String
  let description: String?
  let removed: Bool?
  let published: String
  let updated: String?
  let deleted, nsfw: Bool
  let actorID: String
  let local: Bool?
  let icon: String?
  let banner: String?
  let hidden, postingRestrictedToMods: Bool?
  let instanceID: Int

  enum CodingKeys: String, CodingKey {
    case id, name, title, description, removed, published, updated, deleted, nsfw
    case actorID = "actor_id"
    case local, icon, banner, hidden
    case postingRestrictedToMods = "posting_restricted_to_mods"
    case instanceID = "instance_id"
  }
}

// MARK: - CommentsListCounts

struct CommentsListCounts: Codable {
  let id, commentID, score, upvotes: Int
  let downvotes: Int
  let published: String
  let childCount, hotRank: Int

  enum CodingKeys: String, CodingKey {
    case id
    case commentID = "comment_id"
    case score, upvotes, downvotes, published
    case childCount = "child_count"
    case hotRank = "hot_rank"
  }
}

// MARK: - CommentsListCreator

struct CommentsListCreator: Codable {
  let id: Int
  let name: String
  let banned: Bool
  let published: String
  let actorID: String
  let local, deleted, admin, botAccount: Bool
  let instanceID: Int
  let displayName: String?
  let avatar: String?
  let banner: String?
  let bio: String?

  enum CodingKeys: String, CodingKey {
    case id, name, banned, published
    case actorID = "actor_id"
    case local, deleted, admin
    case botAccount = "bot_account"
    case instanceID = "instance_id"
    case displayName = "display_name"
    case avatar, banner, bio
  }
}

enum CommentSubscribed: String, Codable {
  case notSubscribed = "NotSubscribed"
  case subscribed = "Subscribed"
}

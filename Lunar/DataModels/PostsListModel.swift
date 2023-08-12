//
//  PostsListModel.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import Foundation
import UIKit

// MARK: - PostsModel

struct PostsModel: Codable {
  let posts: [PostElement]
  
  var thumbnailURLs: [String] {
    posts.compactMap {$0.post.thumbnailURL}
  }

  var avatarURLs: [String] {
    posts.compactMap(\.creator.avatar)
  }
}

// MARK: - PostElement

struct PostElement: Codable {
  var image: UIImage?
  let post: PostObject
  let creator: Creator
  let community: Community
  let creatorBannedFromCommunity: Bool
  let counts: Counts
  let subscribed: Subscribed
  let saved, read, creatorBlocked: Bool
  let unreadComments: Int

  enum CodingKeys: String, CodingKey {
    case post, creator, community
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case counts, subscribed, saved, read
    case creatorBlocked = "creator_blocked"
    case unreadComments = "unread_comments"
  }
}

// MARK: - Community

struct Community: Codable {
  let id: Int
  let name, title: String
  let description: String?
  let removed: Bool
  let published: String
  let updated: String?
  let deleted: Bool
  let nsfw: Bool = false
  let actorID: String
  let local: Bool
  let icon: String?
  let hidden, postingRestrictedToMods: Bool
  let instanceID: Int
  let banner: String?

  enum CodingKeys: String, CodingKey {
    case id, name, title, description, removed, published, updated, deleted, nsfw
    case actorID = "actor_id"
    case local, icon, hidden
    case postingRestrictedToMods = "posting_restricted_to_mods"
    case instanceID = "instance_id"
    case banner
  }
}

// MARK: - Counts

struct Counts: Codable {
  let id, postID, comments, score: Int
  let upvotes, downvotes: Int
  let published, newestCommentTimeNecro, newestCommentTime: String
  let featuredCommunity, featuredLocal: Bool
  let hotRank, hotRankActive: Int

  enum CodingKeys: String, CodingKey {
    case id
    case postID = "post_id"
    case comments, score, upvotes, downvotes, published
    case newestCommentTimeNecro = "newest_comment_time_necro"
    case newestCommentTime = "newest_comment_time"
    case featuredCommunity = "featured_community"
    case featuredLocal = "featured_local"
    case hotRank = "hot_rank"
    case hotRankActive = "hot_rank_active"
  }
}

// MARK: - Creator

struct Creator: Codable {
  let id: Int
  let name: String
  let displayName: String?
  let avatar: String?
  let banned: Bool
  let published: String
  let actorID: String
  let bio: String?
  let local: Bool
  let banner: String?
  let deleted, admin, botAccount: Bool
  let instanceID: Int
  let updated, matrixUserID: String?

  enum CodingKeys: String, CodingKey {
    case id, name
    case displayName = "display_name"
    case avatar, banned, published
    case actorID = "actor_id"
    case bio, local, banner, deleted, admin
    case botAccount = "bot_account"
    case instanceID = "instance_id"
    case updated
    case matrixUserID = "matrix_user_id"
  }
}

// MARK: - PostObject

struct PostObject: Codable {
  let id: Int
  let name: String
  let url: String?
  let creatorID, communityID: Int
  let removed, locked: Bool
  let published: String
  let deleted: Bool
  let nsfw: Bool = false
  let thumbnailURL: String?
  let apID: String
  let local: Bool
  let languageID: Int
  let featuredCommunity, featuredLocal: Bool
  let body: String?
  let updated, embedTitle, embedDescription: String?
  let embedVideoURL: String?

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

enum Subscribed: String, Codable {
  case notSubscribed = "NotSubscribed"
}

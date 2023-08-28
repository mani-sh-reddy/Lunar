//
//  CredentialsModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

// MARK: - Welcome

struct SearchModel: Codable {
  let type: String
  let comments: [SearchCommentElement]
  let posts: [SearchPostElement]
  let communities: [CommunityElement]
  let users: [UserElement]

  enum CodingKeys: String, CodingKey {
    case type = "type_"
    case comments, posts, communities, users
  }
}

// MARK: - CommentElement

struct SearchCommentElement: Codable {
  let comment: SearchComment
  let creator: Creator
  let post: SearchCommentPost
  let community: SearchCommunityInfo
  let counts: SearchCommentCounts
  let creatorBannedFromCommunity: Bool
  let subscribed: SubscribedState
  let saved, creatorBlocked: Bool

  enum CodingKeys: String, CodingKey {
    case comment, creator, post, community, counts
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case subscribed, saved
    case creatorBlocked = "creator_blocked"
  }
}

// MARK: - CommentComment

struct SearchComment: Codable {
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
  let updated: String?

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case postID = "post_id"
    case content, removed, published, deleted
    case apID = "ap_id"
    case local, path, distinguished
    case languageID = "language_id"
    case updated
  }
}

// MARK: - CommentCommunity

struct SearchCommunityInfo: Codable {
  let id: Int
  let name, title: String
  let description: String?
  let removed: Bool
  let published: String
  let updated: String?
  let deleted, nsfw: Bool
  let actorID: String
  let local: Bool
  let icon, banner: String?
  let hidden, postingRestrictedToMods: Bool
  let instanceID: Int

  enum CodingKeys: String, CodingKey {
    case id, name, title, description, removed, published, updated, deleted, nsfw
    case actorID = "actor_id"
    case local, icon, banner, hidden
    case postingRestrictedToMods = "posting_restricted_to_mods"
    case instanceID = "instance_id"
  }
}

// MARK: - CommentCounts

struct SearchCommentCounts: Codable {
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

// MARK: - Creator

struct SearchCreator: Codable {
  let id: Int
  let name: String
  let banned: Bool
  let published: String
  let actorID: String
  let local, deleted, admin, botAccount: Bool
  let instanceID: Int
  let avatar: String?
  let displayName, bio: String?
  let banner: String?

  enum CodingKeys: String, CodingKey {
    case id, name, banned, published
    case actorID = "actor_id"
    case local, deleted, admin
    case botAccount = "bot_account"
    case instanceID = "instance_id"
    case avatar
    case displayName = "display_name"
    case bio, banner
  }
}

// MARK: - CommentPost

struct SearchCommentPost: Codable {
  let id: Int
  let name: String
  let url: String?
  let creatorID: Int?
  let communityID: Int?
  let removed, locked: Bool?
  let published: String?
  let deleted, nsfw: Bool?
  let thumbnailURL: String?
  let apID: String?
  let local: Bool?
  let languageID: Int?
  let featuredCommunity, featuredLocal: Bool?
  let body, embedTitle, embedDescription, updated: String?

  enum SearchCodingKeys: String, CodingKey {
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
    case body
    case embedTitle = "embed_title"
    case embedDescription = "embed_description"
    case updated
  }
}

enum SearchSubscribed: String, Codable {
  case notSubscribed = "NotSubscribed"
}

// MARK: - CommunityElement

struct SearchCommunityElement: Codable {
  let community: SearchCommunityInfo
  let subscribed: SubscribedState
  let blocked: Bool
  let counts: SearchCommunityCounts
}

// MARK: - CommunityCounts

struct SearchCommunityCounts: Codable {
  let id, communityID, subscribers, posts: Int
  let comments: Int
  let published: String
  let usersActiveDay, usersActiveWeek, usersActiveMonth, usersActiveHalfYear: Int
  let hotRank: Int

  enum CodingKeys: String, CodingKey {
    case id
    case communityID = "community_id"
    case subscribers, posts, comments, published
    case usersActiveDay = "users_active_day"
    case usersActiveWeek = "users_active_week"
    case usersActiveMonth = "users_active_month"
    case usersActiveHalfYear = "users_active_half_year"
    case hotRank = "hot_rank"
  }
}

// MARK: - PostElement

struct SearchPostElement: Codable {
  let post: SearchCommentPost
  let creator: Creator
  let community: SearchCommunityInfo
  let creatorBannedFromCommunity: Bool
  let counts: SearchPostCounts
  let subscribed: SubscribedState?
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

// MARK: - PostCounts

struct SearchPostCounts: Codable {
  let id, postID, comments, score: Int
  let upvotes, downvotes: Int
  let published, newestCommentTimeNecro, newestCommentTime: String
  let featuredCommunity, featuredLocal: Bool
  let hotRank, hotRankActive, communityID: Int
  let creatorID: Int?

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
    case communityID = "community_id"
    case creatorID = "creator_id"
  }
}

// MARK: - User

struct UserElement: Codable {
  let person: Creator
  let counts: SearchUserCounts
}

// MARK: - UserCounts

struct SearchUserCounts: Codable {
  let id, personID, postCount, postScore: Int
  let commentCount, commentScore: Int

  enum CodingKeys: String, CodingKey {
    case id
    case personID = "person_id"
    case postCount = "post_count"
    case postScore = "post_score"
    case commentCount = "comment_count"
    case commentScore = "comment_score"
  }
}

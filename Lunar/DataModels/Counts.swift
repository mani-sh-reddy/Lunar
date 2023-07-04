//
//  Counts.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct Counts: Codable {
  let id: Int?
  let published: String?

  let posts: Int?
  let postID: Int?
  let postCount: Int?
  let postScore: Int?
  let subscribers: Int?

  let comments: Int?
  let commentCount: Int?
  let commentScore: Int?
  let commentID: Int?
  let score: Int?
  let childCount: Int?

  let communities: Int?
  let communityID: Int?

  let users: Int?
  let personID: Int?
  let creatorID: Int?
  let usersActiveDay: Int?
  let usersActiveWeek: Int?
  let usersActiveMonth: Int?
  let usersActiveHalfYear: Int?

  let siteID: Int?
  let hotRank: Int?
  let hotRankActive: Int?
  let upvotes: Int?
  let downvotes: Int?

  let newestCommentTimeNecro: String?
  let newestCommentTime: String?

  let featuredCommunity: Bool?
  let featuredLocal: Bool?

  enum CodingKeys: String, CodingKey {
    case id
    case published

    case posts
    case postID = "post_id"
    case postCount = "post_count"
    case postScore = "post_score"
    case subscribers

    case comments
    case commentID = "comment_id"
    case commentCount = "comment_count"
    case commentScore = "comment_score"
    case score
    case childCount = "child_count"

    case communities
    case communityID = "community_id"

    case users
    case personID = "person_id"
    case creatorID = "creator_id"
    case usersActiveDay = "users_active_day"
    case usersActiveWeek = "users_active_week"
    case usersActiveMonth = "users_active_month"
    case usersActiveHalfYear = "users_active_half_year"

    case siteID = "site_id"
    case hotRank = "hot_rank"
    case hotRankActive = "hot_rank_active"
    case upvotes
    case downvotes

    case newestCommentTimeNecro = "newest_comment_time_necro"
    case newestCommentTime = "newest_comment_time"

    case featuredCommunity = "featured_community"
    case featuredLocal = "featured_local"
  }
}

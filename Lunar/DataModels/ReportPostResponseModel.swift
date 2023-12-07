//
//  ReportPostResponseModel.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Foundation

struct ReportResponseModel: Codable {
  let postReportModel: PostReportModel?
  let commentReportModel: CommentReportModel?
  let privateMessageReportModel: PrivateMessageReportModel?

  enum CodingKeys: String, CodingKey {
    case postReportModel = "post_report_view"
    case commentReportModel = "comment_report_view"
    case privateMessageReportModel = "private_message_report_view"
  }
}

struct PostReportModel: Codable {
  let postReport: PostReportObject
  let post: Post
  let community: Community
  let creator, postCreator: Person
  let creatorBannedFromCommunity: Bool
  let counts: Counts

  enum CodingKeys: String, CodingKey {
    case postReport = "post_report"
    case post, community, creator
    case postCreator = "post_creator"
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case counts
  }
}

struct CommentReportModel: Codable {
  let commentReport: CommentReportObject
  let comment: Comment
  let post: Post
  let community: Community
  let creator, commentCreator: Person
  let counts: Counts
  let creatorBannedFromCommunity: Bool

  enum CodingKeys: String, CodingKey {
    case commentReport = "comment_report"
    case comment, post, community, creator
    case commentCreator = "comment_creator"
    case counts
    case creatorBannedFromCommunity = "creator_banned_from_community"
  }
}

struct PrivateMessageReportModel: Codable {
  let privateMessageReport: PrivateMessageReportObject
  let privateMessage: PrivateMessage
  let privateMessageCreator, creator: Person

  enum CodingKeys: String, CodingKey {
    case privateMessageReport = "private_message_report"
    case privateMessage = "private_message"
    case privateMessageCreator = "private_message_creator"
    case creator
  }
}

struct PostReportObject: Codable {
  let id, creatorID, postID: Int
  let originalPostName: String
  let originalPostURL: String
  let originalPostBody, reason: String
  let resolved: Bool
  let published: String

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case postID = "post_id"
    case originalPostName = "original_post_name"
    case originalPostURL = "original_post_url"
    case originalPostBody = "original_post_body"
    case reason, resolved, published
  }
}

struct CommentReportObject: Codable {
  let id, creatorID, commentID: Int
  let originalCommentText, reason: String
  let resolved: Bool
  let published: String

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case commentID = "comment_id"
    case originalCommentText = "original_comment_text"
    case reason, resolved, published
  }
}

struct PrivateMessageReportObject: Codable {
  let id, creatorID, privateMessageID: Int
  let originalPmText, reason: String
  let resolved: Bool
  let published: String

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case privateMessageID = "private_message_id"
    case originalPmText = "original_pm_text"
    case reason, resolved, published
  }
}

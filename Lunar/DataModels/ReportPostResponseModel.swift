//
//  ReportPostResponseModel.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Foundation

struct ReportPostResponseModel: Codable {
  let postReportView: ReportModel

  enum CodingKeys: String, CodingKey {
    case postReportView = "post_report_view"
  }
}

struct ReportModel: Codable {
  let postReport: Report
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

struct Report: Codable {
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

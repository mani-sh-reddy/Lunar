//
//  KbinPostModel.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

struct KbinPostModel: Codable {
  let context: String
  let id: String
  let type: String
  let hydraMember: [HydraMember]
  let hydraTotalItems: Int
  let hydraView: HydraView

  enum CodingKeys: String, CodingKey {
    case context = "@context"
    case id = "@id"
    case type = "@type"
    case hydraMember = "hydra:member"
    case hydraTotalItems = "hydra:totalItems"
    case hydraView = "hydra:view"
  }
}

// MARK: - HydraMember

struct HydraMember: Codable {
  let id, type: String
  let magazine: Magazine
  let user: User
  let image: JSONNull?
  let body: String
  let isAdult: Bool
  let comments, uv, dv, score: Int
  let visibility: String
  let createdAt, lastActive: Date
  let bestComments: [BestComment]
  let hydraMemberID: Int

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case magazine, user, image, body, isAdult, comments, uv, dv, score, visibility, createdAt, lastActive, bestComments
    case hydraMemberID = "id"
  }
}

// MARK: - BestComment

struct BestComment: Codable {
  let id, type: String
  let user: User
  let image: JSONNull?
  let body: String
  let uv: Int
  let createdAt, lastActive: Date
  let bestCommentID: Int

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case user, image, body, uv, createdAt, lastActive
    case bestCommentID = "id"
  }
}

// MARK: - User

struct User: Codable {
  let id, type, username: String
  let avatar: Avatar

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case username, avatar
  }
}

// MARK: - Avatar

struct Avatar: Codable {
  let id, type, filePath: String
  let width, height: Int

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case filePath, width, height
  }
}

// MARK: - Magazine

struct Magazine: Codable {
  let id, type, name: String

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case name
  }
}

// MARK: - HydraView

struct HydraView: Codable {
  let id, type, hydraFirst, hydraLast: String
  let hydraNext: String

  enum CodingKeys: String, CodingKey {
    case id = "@id"
    case type = "@type"
    case hydraFirst = "hydra:first"
    case hydraLast = "hydra:last"
    case hydraNext = "hydra:next"
  }
}

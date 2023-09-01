//
//  Site.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

struct Site: Codable {
  let id: Int?
  let name: String?
  let sidebar: String?
  let published: String?
  let updated: String?
  let icon: String?
  let banner: String?
  let description: String?
  let actorID: String?
  let lastRefreshedAt: String?
  let inboxURL: String?
  let publicKey: String?
  let instanceID: Int?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case sidebar
    case published
    case updated
    case icon
    case banner
    case description
    case actorID = "actor_id"
    case lastRefreshedAt = "last_refreshed_at"
    case inboxURL = "inbox_url"
    case publicKey = "public_key"
    case instanceID = "instance_id"
  }
}

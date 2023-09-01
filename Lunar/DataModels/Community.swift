//
//  Community.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct Community: Codable {
  let id: Int
  
  let name: String
  let title: String
  let published: String
  let actorID: String
  
  let instanceID: Int
  
  let removed: Bool
  let deleted: Bool
  
  let nsfw: Bool = false
  
  let local: Bool
  let hidden: Bool
  let postingRestrictedToMods: Bool
  
  let description: String?
  let icon: String?
  let banner: String?
  let updated: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case title
    case removed
    case published
    case deleted
    case nsfw
    case actorID = "actor_id"
    case local, hidden
    case postingRestrictedToMods = "posting_restricted_to_mods"
    case instanceID = "instance_id"
    case description
    case updated
    case icon
    case banner
  }
}

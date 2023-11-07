//
//  Person.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct Person: Codable {
  let id: Int?
  let name: String
  let banned: Bool
  let published: String?
  let actorID: String
  let local: Bool
  let deleted: Bool
  let admin: Bool?
  let botAccount: Bool
  let instanceID: Int?
  let avatar: String?
  let displayName: String?
  let bio: String?
  let banner: String?
  let matrixUserID: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case banned
    case published
    case actorID = "actor_id"
    case local
    case deleted
    case admin
    case botAccount = "bot_account"
    case instanceID = "instance_id"
    case avatar
    case displayName = "display_name"
    case bio
    case banner
    case matrixUserID = "matrix_user_id"
  }
}

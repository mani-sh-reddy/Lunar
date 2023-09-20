//
//  AccountModel.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Defaults
import Foundation

struct AccountModel: Codable, Hashable, Defaults.Serializable {
  var userID: String = ""
  var name: String = ""
  var email: String = ""
  var avatarURL: String = ""
  var actorID: String = ""
  var displayName: String = ""
  var postScore: Int = 0
  var postCount: Int = 0
  var commentScore: Int = 0
  var commentCount: Int = 0
}

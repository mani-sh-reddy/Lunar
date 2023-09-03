//
//  AccountModel.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Foundation

struct AccountModel: Codable, Hashable {
  var userID: String = ""
  var name: String = ""
  var email: String = ""
  var avatarURL: String = ""
  var actorID: String = ""
}
//
//  LocalUserProperties.swift
//  Lunar
//
//  Created by Mani on 10/09/2023.
//

import Foundation

struct LocalUserProperties: Codable {
  let localUser: LocalUser
  let person: Person
  let counts: Counts
  
  enum CodingKeys: String, CodingKey {
    case localUser = "local_user"
    case person
    case counts
  }
}

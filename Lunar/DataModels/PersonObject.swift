//
//  PersonObject.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct PersonObject: Codable {
  let person: Person
  let counts: Counts
  let localUser: LocalUser?

  enum CodingKeys: String, CodingKey {
    case localUser = "local_user"
    case person
    case counts
  }
}

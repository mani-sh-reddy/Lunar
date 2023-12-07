//
//  BlockUserResponseModel.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Foundation

struct BlockUserResponseModel: Codable {
  let person: PersonObject?
  let blocked: Bool

  enum CodingKeys: String, CodingKey {
    case person = "person_view"
    case blocked
  }
}

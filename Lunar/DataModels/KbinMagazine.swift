//
//  KbinMagazine.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

struct KbinMagazine: Codable {
  let name: String
  let magazineID: Int
  let icon: KbinImage?
  let isUserSubscribed, isBlockedByUser: Bool?
  let apID: String?
  let apProfileID: String?

  enum CodingKeys: String, CodingKey {
    case name
    case magazineID = "magazineId"
    case icon, isUserSubscribed, isBlockedByUser
    case apID = "apId"
    case apProfileID = "apProfileId"
  }
}

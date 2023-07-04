//
//  PrivateMessage.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Foundation

struct PrivateMessage: Codable {
  let id: Int
  let creatorID: Int
  let recipientID: Int
  let content: String
  let deleted: Bool
  let read: Bool
  let published: String
  let apID: String
  let local: Bool

  enum CodingKeys: String, CodingKey {
    case id
    case creatorID = "creator_id"
    case recipientID = "recipient_id"
    case content, deleted, read, published
    case apID = "ap_id"
    case local
  }
}

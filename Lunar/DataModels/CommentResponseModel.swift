//
//  CommentResponseModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct CommentResponseModel: Codable {
  let comment: CommentObject
  let recipientIDS: [JSONAny]

  enum CodingKeys: String, CodingKey {
    case comment = "comment_view"
    case recipientIDS = "recipient_ids"
  }
}

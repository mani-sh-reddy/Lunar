//
//  VoteResponseModel.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Foundation

// MARK: - Welcome

struct VoteResponseModel: Codable {
  let post: PostObject?
  let comment: CommentObject?

  enum CodingKeys: String, CodingKey {
    case post = "post_view"
    case comment = "comment_view"
  }
}

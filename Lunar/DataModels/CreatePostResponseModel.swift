//
//  CreatePostResponseModel.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Foundation

// MARK: - CreatePostResponseModel

struct CreatePostResponseModel: Codable {
  let post: PostObject?

  enum CodingKeys: String, CodingKey {
    case post = "post_view"
  }
}

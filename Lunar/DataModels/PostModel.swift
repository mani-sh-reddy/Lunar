//
//  PostModel.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import Foundation

struct PostModel: Codable {
  let posts: [PostObject]
  let nextPageCursor: String?

  enum CodingKeys: String, CodingKey {
    case posts
    case nextPageCursor = "next_page"
  }

  var thumbnailURLs: [String] {
    posts.compactMap(\.post.thumbnailURL)
  }

  var imageURLs: [String] {
    var uniqueURLs = Set<String>()
    posts.forEach {
      if let thumbnailURL = $0.post.thumbnailURL {
        uniqueURLs.insert(thumbnailURL)
      }
      if let postURL = $0.post.url, postURL.isValidExternalImageURL() {
        uniqueURLs.insert(postURL)
      }
    }
    return Array(uniqueURLs)
  }

  var avatarURLs: [String] {
    posts.compactMap(\.creator.avatar)
  }
}

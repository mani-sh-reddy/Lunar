//
//  PersonModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct PersonModel: Codable {
  let person: PersonObject
  let comments: [CommentObject]
  let posts: [PostObject]
  let moderates: [Moderates]

  enum CodingKeys: String, CodingKey {
    case person = "person_view"
    case comments
    case posts
    case moderates
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
}

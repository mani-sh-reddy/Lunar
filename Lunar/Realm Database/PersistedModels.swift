//
//  PersistedModels.swift
//  Lunar
//
//  Created by Mani on 22/09/2023.
//

import Foundation
import RealmSwift

// MARK: - PersistedObject

class PersistedObject: Object, Identifiable {
  @Persisted(primaryKey: true) var label: String
  @Persisted var posts: List<PersistedPostModel>
  
  convenience init(
    label: String,
    posts: List<PersistedPostModel>
  ) {
    self.init()
    self.label = label
    self.posts = posts
  }
  
}

// MARK: - PersistedPostModel

class PersistedPostModel: Object, Identifiable {
  @Persisted(primaryKey: true) var id: Int
  @Persisted var title: String
  @Persisted var postPublished: String
  @Persisted var url: String
  @Persisted var postBody: String
  @Persisted var thumbnailURL: String
  @Persisted var postUpvotes: Int
  @Persisted var postDownvotes: Int
  @Persisted var numberOfComments: Int
  @Persisted var instance: String
  @Persisted var communityName: String

  convenience init(
    id: Int,
    title: String,
    postPublished: String,
    url: String,
    postBody: String,
    thumbnailURL: String,
    postUpvotes: Int,
    postDownvotes: Int,
    numberOfComments: Int,
    instance: String,
    communityName: String
  ) {
    self.init()
    self.id = id
    self.title = title
    self.postPublished = postPublished
    self.url = url
    self.postBody = postBody
    self.thumbnailURL = thumbnailURL
    self.postUpvotes = postUpvotes
    self.postDownvotes = postDownvotes
    self.numberOfComments = numberOfComments
    self.instance = instance
    self.communityName = communityName
  }
}

// MARK: - PersistedCommentsModel

class PersistedCommentsModel: Object, Identifiable {
  @Persisted(primaryKey: true) var postID: Int
  @Persisted var commentBody: String
  @Persisted var commentPublished: String
  @Persisted var commentCreatorName: String
  @Persisted var commentUpvotes: Int
  @Persisted var commentDownvotes: Int

  convenience init(
    postID: Int,
    commentBody: String,
    commentPublished: String,
    commentCreatorName: String,
    commentUpvotes: Int,
    commentDownvotes: Int
  ) {
    self.init()
    self.postID = postID
    self.commentBody = commentBody
    self.commentPublished = commentPublished
    self.commentCreatorName = commentCreatorName
    self.commentUpvotes = commentUpvotes
    self.commentDownvotes = commentDownvotes
  }
}

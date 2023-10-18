//
//  RealmPost.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation
import RealmSwift

class RealmPost: Object, ObjectKeyIdentifiable {
  // MARK: - Post

  @Persisted(primaryKey: true) var postID: Int
  @Persisted var postName: String
  @Persisted var postPublished: String
  @Persisted var postURL: String?
  @Persisted var postBody: String?
  @Persisted var postThumbnailURL: String?

  // MARK: - Person

  @Persisted var personID: Int?
  @Persisted var personName: String
  @Persisted var personPublished: String?
  @Persisted var personActorID: String
  @Persisted var personInstanceID: Int?
  @Persisted var personAvatar: String?
  @Persisted var personDisplayName: String?
  @Persisted var personBio: String?
  @Persisted var personBanner: String?

  // MARK: - Community

  @Persisted var communityID: Int
  @Persisted var communityName: String
  @Persisted var communityTitle: String
  @Persisted var communityActorID: String
  @Persisted var communityInstanceID: Int
  @Persisted var communityDescription: String?
  @Persisted var communityIcon: String?
  @Persisted var communityBanner: String?
  @Persisted var communityUpdated: String?

  // MARK: - Counts

  @Persisted var postScore: Int?
  @Persisted var postCommentCount: Int?
  @Persisted var upvotes: Int?
  @Persisted var downvotes: Int?

  // MARK: - Convenience initializer

  convenience init(
    postID: Int,
    postName: String,
    postPublished: String,
    postURL: String?,
    postBody: String?,
    postThumbnailURL: String?,
    personID: Int?,
    personName: String,
    personPublished: String?,
    personActorID: String,
    personInstanceID: Int?,
    personAvatar: String?,
    personDisplayName: String?,
    personBio: String?,
    personBanner: String?,
    communityID: Int,
    communityName: String,
    communityTitle: String,
    communityActorID: String,
    communityInstanceID: Int,
    communityDescription: String?,
    communityIcon: String?,
    communityBanner: String?,
    communityUpdated: String?,
    postScore: Int?,
    postCommentCount: Int?,
    upvotes: Int?,
    downvotes: Int?
  ) {
    self.init()
    self.postID = postID
    self.postName = postName
    self.postPublished = postPublished
    self.postURL = postURL
    self.postBody = postBody
    self.postThumbnailURL = postThumbnailURL

    self.personID = personID
    self.personName = personName
    self.personPublished = personPublished
    self.personActorID = personActorID
    self.personInstanceID = personInstanceID
    self.personAvatar = personAvatar
    self.personDisplayName = personDisplayName
    self.personBio = personBio
    self.personBanner = personBanner

    self.communityID = communityID
    self.communityName = communityName
    self.communityTitle = communityTitle
    self.communityActorID = communityActorID
    self.communityInstanceID = communityInstanceID
    self.communityDescription = communityDescription
    self.communityIcon = communityIcon
    self.communityBanner = communityBanner
    self.communityUpdated = communityUpdated

    self.postScore = postScore
    self.postCommentCount = postCommentCount
    self.upvotes = upvotes
    self.downvotes = downvotes
  }
}

//
//  Batch.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Foundation
import RealmSwift

// periphery:ignore
class Batch: Object, ObjectKeyIdentifiable {
  @Persisted var realmPosts: List<RealmPost>

  // MARK: - Batch

  @Persisted(primaryKey: true) var batchID: String

  @Persisted var instance: String
  @Persisted var sort: String?
  @Persisted var type: String?
  @Persisted var numberOfPosts: Int?
  @Persisted var page: Int
  @Persisted var latestTime: Double
  @Persisted var userUsed: Int
  /// If not logged in, = 0
  @Persisted var communityID: Int
  /// If posts not community specific, = 0
  @Persisted var personID: Int
  /// If posts not person specific, = 0

  // MARK: - Convenience initializer

  convenience init(
    batchID: String,
    instance: String,
    sort: String,
    type: String,
    numberOfPosts: Int?,
    page: Int,
    latestTime: Double,
    userUsed: Int,
    communityID: Int,
    personID: Int
    //    realmPosts: List<RealmPost>
  ) {
    self.init()

    //    batchID = "instance_\(instance)" +
    //      "__sort_\(sort)" +
    //      "__type_\(type)" +
    //      "__userUsed_\(userUsed)" +
    //      "__communityID_\(communityID)" +
    //      "__personID_\(personID)"

    self.batchID = batchID
    self.instance = instance
    self.sort = sort
    self.type = type
    self.numberOfPosts = numberOfPosts
    self.page = page
    self.latestTime = latestTime
    self.userUsed = userUsed
    self.communityID = communityID
    self.personID = personID
    //    self.realmPosts = realmPosts
  }
}

//
//  RealmDataState.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Foundation
import RealmSwift

class RealmDataState: Object, ObjectKeyIdentifiable {
  // MARK: - Data State

  @Persisted(primaryKey: true) var identifier: String
  @Persisted var instance: String
  @Persisted var sortParameter: String?
  @Persisted var typeParameter: String?
  @Persisted var numberOfPosts: Int?
  @Persisted var maxPage: Int
  @Persisted var latestTime: Double
  @Persisted var userUsed: String? /// if the user is logged in - ACTORID STRING
  @Persisted var communityID: String? /// If posts are community specific - ACTORID STRING
  @Persisted var personID: String? /// If posts are person specific - ACTORID STRING

  // to-many link with realm items (posts, comments, ...)
  @Persisted var items: List<RealmPost>

  // MARK: - Convenience initializer

  convenience init(
    instance: String,
    sortParameter: String?,
    typeParameter: String?,
    numberOfPosts: Int?,
    maxPage: Int,
    latestTime: Double,
    userUsed: String?,
    communityID: String?,
    personID: String?
  ) {
    self.init()

    identifier = IdentifierGenerators().postIdentifier(
      instance: instance,
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      userUsed: userUsed,
      communityID: communityID,
      personID: personID
    )

    self.instance = instance
    self.sortParameter = sortParameter
    self.typeParameter = typeParameter
    self.numberOfPosts = numberOfPosts
    self.maxPage = maxPage
    self.latestTime = latestTime
    self.userUsed = userUsed
    self.communityID = communityID
    self.personID = personID
  }
}

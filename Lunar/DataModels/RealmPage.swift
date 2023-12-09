//
//  RealmPage.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation
import RealmSwift

// periphery:ignore
class RealmPage: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var pageCursor: String
  @Persisted var timestamp: Date
  @Persisted var sort: String?
  @Persisted var type: String?
  @Persisted var communityID: Int?
  @Persisted var personID: Int?
  @Persisted var filterKey: String

  convenience init(
    pageCursor: String,
    timestamp _: Date = Date.now,
    sort: String?,
    type: String?,
    communityID: Int?,
    personID: Int?,
    filterKey: String
  ) {
    self.init()

    self.pageCursor = pageCursor
    self.sort = sort
    self.type = type
    self.communityID = communityID
    self.personID = personID
    self.filterKey = filterKey
  }
}

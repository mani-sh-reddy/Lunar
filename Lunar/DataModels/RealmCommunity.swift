//
//  RealmCommunity.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation
import RealmSwift

class RealmCommunity: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: Int

  @Persisted var name: String
  @Persisted var title: String?
  @Persisted var actorID: String
  @Persisted var instanceID: Int
  @Persisted var descriptionText: String?
  @Persisted var icon: String?
  @Persisted var banner: String?
  @Persisted var postingRestrictedToMods: Bool
  @Persisted var published: String?

  // MARK: - Counts

  @Persisted var subscribers: Int?
  @Persisted var posts: Int?
  @Persisted var comments: Int?

  // MARK: - User Action

  @Persisted var subscribed: SubscribedState

  // MARK: - Convenience initializer

  convenience init(
    id: Int,
    name: String,
    title: String?,
    actorID: String,
    instanceID: Int,
    descriptionText: String?,
    icon: String?,
    banner: String?,
    postingRestrictedToMods: Bool,
    published: String?,
    subscribers: Int?,
    posts: Int?,
    comments: Int?,
    subscribed: SubscribedState
  ) {
    self.init()
    self.id = id
    self.name = name
    self.title = title
    self.actorID = actorID
    self.instanceID = instanceID
    self.descriptionText = descriptionText
    self.icon = icon
    self.banner = banner
    self.postingRestrictedToMods = postingRestrictedToMods
    self.published = published
    self.subscribers = subscribers
    self.posts = posts
    self.comments = comments
    self.subscribed = subscribed
  }
}

//
//  RealmPrivateMessage.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Foundation

import Foundation
import RealmSwift

// periphery:ignore
class RealmPrivateMessage: Object, ObjectKeyIdentifiable {
  // MARK: - Message

  @Persisted(primaryKey: true) var messageID: Int

  @Persisted var messageContent: String
  @Persisted var messageDeleted: Bool
  @Persisted var messageRead: Bool
  @Persisted var messagePublished: String
  @Persisted var messageApID: String
  @Persisted var messageIsLocal: Bool
  @Persisted var messageTimeAgo: String

  // MARK: - Creator

  @Persisted var creatorID: Int
  @Persisted var creatorName: String
  @Persisted var creatorAvatar: String
  @Persisted var creatorActorID: String

  // MARK: - Recipient

  @Persisted var recipientID: Int
  @Persisted var recipientName: String
  @Persisted var recipientAvatar: String
  @Persisted var recipientActorID: String

  // MARK: - Convenience initializer

  convenience init(
    messageID: Int,
    messageContent: String,
    messageDeleted: Bool,
    messageRead: Bool,
    messagePublished: String,
    messageApID: String,
    messageIsLocal: Bool,
    creatorID: Int,
    creatorName: String,
    creatorAvatar: String,
    creatorActorID: String,
    recipientID: Int,
    recipientName: String,
    recipientAvatar: String,
    recipientActorID: String
  ) {
    self.init()
    self.messageID = messageID
    self.messageContent = messageContent
    self.messageDeleted = messageDeleted
    self.messageRead = messageRead
    self.messagePublished = messagePublished
    self.messageApID = messageApID
    self.messageIsLocal = messageIsLocal
    messageTimeAgo = TimestampParser().parse(originalTimestamp: messagePublished) ?? ""
    self.creatorID = creatorID
    self.creatorName = creatorName
    self.creatorAvatar = creatorAvatar
    self.creatorActorID = creatorActorID
    self.recipientID = recipientID
    self.recipientName = recipientName
    self.recipientAvatar = recipientAvatar
    self.recipientActorID = recipientActorID
  }
}

//
//  PostObject.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation
import SwiftUI

struct PostObject: Codable {
  var image: UIImage?
  let post: Post
  let creator: Person
  let community: Community
  var counts: Counts
  var subscribed: SubscribedState

  let saved: Bool
  let read: Bool
  let creatorBlocked: Bool
  let creatorBannedFromCommunity: Bool

  let unreadComments: Int

  var myVote: Int?

  enum CodingKeys: String, CodingKey {
    case post, creator, community
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case counts, subscribed, saved, read
    case creatorBlocked = "creator_blocked"
    case unreadComments = "unread_comments"
    case myVote = "my_vote"
  }
}

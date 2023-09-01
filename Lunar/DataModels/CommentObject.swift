//
//  CommentObject.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct CommentObject: Codable {
  let comment: Comment
  let creator: Person
  let post: Post
  let community: Community
  let counts: Counts
  let subscribed: SubscribedState?
  
  let saved: Bool
  let creatorBannedFromCommunity: Bool
  let creatorBlocked: Bool
  
  var myVote: Int?
  
  var isCollapsed: Bool = false
  var isShrunk: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case comment, creator, post, community, counts
    case creatorBannedFromCommunity = "creator_banned_from_community"
    case subscribed, saved
    case creatorBlocked = "creator_blocked"
    case myVote = "my_vote"
  }
}

//
//  RealmThawFunctions.swift
//  Lunar
//
//  Created by Mani on 21/10/2023.
//

import Foundation
import RealmSwift
import SwiftUI

class RealmThawFunctions {
  let hapticsLight = UIImpactFeedbackGenerator(style: .light)
  let hapticsSoft = UIImpactFeedbackGenerator(style: .soft)

  func subscribe(post: RealmPost, subscribedState: SubscribedState) {
    let realm = try! Realm()
    try! realm.write {
      if let thawedPost = post.thaw() {
        thawedPost.communitySubscribed = subscribedState
      }
    }
  }

  func deletePost(post: RealmPost) {
    let thawedPost = post.thaw()
    if thawedPost?.isInvalidated == false {
      let thawedRealm = thawedPost!.realm!
      try! thawedRealm.write {
        if let thawedPost {
          thawedRealm.delete(thawedPost)
        }
      }
    }
    hapticsSoft.impactOccurred(intensity: 0.5)
  }

  func deleteCommunity(community: RealmCommunity) {
    let thawedCommunity = community.thaw()
    if thawedCommunity?.isInvalidated == false {
      let thawedRealm = thawedCommunity!.realm!
      try! thawedRealm.write {
        if let thawedCommunity {
          thawedRealm.delete(thawedCommunity)
        }
      }
    }
    hapticsSoft.impactOccurred(intensity: 0.5)
  }

  func deleteAllCommunities() {
    let realm = try! Realm()
    try! realm.write {
      let communities = realm.objects(RealmCommunity.self)
      realm.delete(communities)
    }
  }

  func hideAction(post: RealmPost) {
    let realm = try! Realm()
    try! realm.write {
      if let thawedPost = post.thaw() {
        thawedPost.postHidden = true
      }
    }
    hapticsSoft.impactOccurred(intensity: 0.5)
  }

  func minimiseToggleAction(post: RealmPost) {
    let realm = try! Realm()
    try! realm.write {
      if let thawedPost = post.thaw() {
        thawedPost.postMinimised.toggle()
      }
    }
    hapticsSoft.impactOccurred(intensity: 0.5)
  }

  func upvoteAction(post: RealmPost) {
    let realm = try! Realm()
    try! realm.write {
      if let thawedPost = post.thaw() {
        if post.postMyVote == 1 {
          // User has already upvoted, so remove the upvote
          if let currentUpvotes = thawedPost.upvotes {
            thawedPost.upvotes = currentUpvotes - 1
          }
          thawedPost.postMyVote = 0
        } else if post.postMyVote == 0 {
          // User hasn't upvoted or downvoted, so upvote the post
          if let currentUpvotes = thawedPost.upvotes {
            thawedPost.upvotes = currentUpvotes + 1
          }
          thawedPost.postMyVote = 1
        } else if post.postMyVote == -1 {
          // User is changing a downvote to an upvote
          if let currentUpvotes = thawedPost.upvotes, let currentDownvotes = thawedPost.downvotes {
            thawedPost.upvotes = currentUpvotes + 1
            thawedPost.downvotes = currentDownvotes - 1
          }
          thawedPost.postMyVote = 1
        }
      }
    }
    hapticsLight.impactOccurred()
  }

  func downvoteAction(post: RealmPost) {
    let realm = try! Realm()
    try! realm.write {
      if let thawedPost = post.thaw() {
        if post.postMyVote == -1 {
          // User has already downvoted, so remove the downvote
          if let currentDownvotes = thawedPost.downvotes {
            thawedPost.downvotes = currentDownvotes - 1
          }
          thawedPost.postMyVote = 0
        } else if post.postMyVote == 0 {
          // User hasn't downvoted or upvoted, so downvote the post
          if let currentDownvotes = thawedPost.downvotes {
            thawedPost.downvotes = currentDownvotes + 1
          }
          thawedPost.postMyVote = -1
        } else if post.postMyVote == 1 {
          // User is changing an upvote to a downvote
          if let currentUpvotes = thawedPost.upvotes, let currentDownvotes = thawedPost.downvotes {
            thawedPost.downvotes = currentDownvotes + 1
            thawedPost.upvotes = currentUpvotes - 1
          }
          thawedPost.postMyVote = -1
        }
      }
    }
    hapticsLight.impactOccurred()
  }
}

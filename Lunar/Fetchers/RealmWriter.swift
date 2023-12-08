//
//  RealmWriter.swift
//  Lunar
//
//  Created by Mani on 06/12/2023.
//

import RealmSwift
import SwiftUI

class RealmWriter {
  let realm = try! Realm()

  func writePost(
    posts: [PostObject],
    sort: String,
    type: String,
    filterKey: String
  ) {
    try! realm.write {
      for post in posts {
        guard !post.creatorBlocked else { return }

        let realmPost = RealmPost(
          postID: post.post.id,
          postName: post.post.name,
          postPublished: post.post.published,
          postURL: post.post.url,
          postBody: post.post.body,
          postThumbnailURL: post.post.thumbnailURL,
          postFeatured: post.post.featuredCommunity || post.post.featuredLocal,
          personID: post.creator.id,
          personName: post.creator.name,
          personPublished: post.creator.published,
          personActorID: post.creator.actorID,
          personInstanceID: post.creator.instanceID,
          personAvatar: post.creator.avatar,
          personDisplayName: post.creator.displayName,
          personBio: post.creator.bio,
          personBanner: post.creator.banner,
          communityID: post.community.id,
          communityName: post.community.name,
          communityTitle: post.community.title,
          communityActorID: post.community.actorID,
          communityInstanceID: post.community.instanceID,
          communityDescription: post.community.description,
          communityIcon: post.community.icon,
          communityBanner: post.community.banner,
          communityUpdated: post.community.updated,
          communitySubscribed: post.subscribed,
          postScore: post.counts.postScore,
          postCommentCount: post.counts.comments,
          upvotes: post.counts.upvotes,
          downvotes: post.counts.downvotes,
          postMyVote: post.myVote ?? 0,
          postHidden: false,
          postMinimised: post.post.featuredCommunity || post.post.featuredLocal,
          sort: sort,
          type: type,
          filterKey: filterKey
        )
        realm.add(realmPost, update: .modified)
      }
    }
  }

  func writePrivateMessage(
    privateMessages: [PrivateMessageObject]
  ) {
    let realm = try! Realm()

    try! realm.write {
      for message in privateMessages {
        let realmPrivateMessage = RealmPrivateMessage(
          messageID: message.privateMessage.id,
          messageContent: message.privateMessage.content,
          messageDeleted: message.privateMessage.deleted,
          messageRead: message.privateMessage.deleted,
          messagePublished: message.privateMessage.published,
          messageApID: message.privateMessage.apID,
          messageIsLocal: message.privateMessage.local,
          creatorID: message.creator.id ?? 0,
          creatorName: message.creator.name,
          creatorAvatar: message.creator.avatar ?? "",
          creatorActorID: message.creator.actorID,
          recipientID: message.recipient.id ?? 0,
          recipientName: message.recipient.name,
          recipientAvatar: message.recipient.avatar ?? "",
          recipientActorID: message.recipient.actorID
        )
        realm.add(realmPrivateMessage, update: .modified)
      }
    }
  }

  func writeCommunity(
    communities: [CommunityObject]
  ) {
    let realm = try! Realm()

    try! realm.write {
      for community in communities {
        let fetchedCommunity = RealmCommunity(
          id: community.community.id,
          name: community.community.name,
          title: community.community.title,
          actorID: community.community.actorID,
          instanceID: community.community.instanceID,
          descriptionText: community.community.description,
          icon: community.community.icon,
          banner: community.community.banner,
          postingRestrictedToMods: community.community.postingRestrictedToMods,
          published: community.community.published,
          subscribers: community.counts.subscribers,
          posts: community.counts.posts,
          comments: community.counts.comments,
          subscribed: community.subscribed
        )
        realm.add(fetchedCommunity, update: .modified)
      }
    }
  }
}

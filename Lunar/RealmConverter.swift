//
//  RealmConverter.swift
//  Lunar
//
//  Created by Mani on 08/12/2023.
//

import Foundation

class RealmConverter {
  func toCommunity(community: CommunityObject) -> RealmCommunity {
    RealmCommunity(
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
  }

  func toPost(post: PostObject) -> RealmPost {
    RealmPost(
      postID: post.post.id,
      postName: post.post.name,
      postPublished: post.post.published,
      postURL: post.post.url,
      postBody: post.post.body,
      postThumbnailURL: post.post.thumbnailURL,
      postFeatured: post.post.featuredLocal,
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
      postMinimised: false,
      sort: nil,
      type: nil,
      filterKey: ""
    )
  }
}

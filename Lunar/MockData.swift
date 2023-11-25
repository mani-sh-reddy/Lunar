//
//  MockData.swift
//  Lunar
//
//  Created by Mani on 25/11/2023.
//

import Foundation

class MockData {
  let post = RealmPost(
    postID: 1,
    postName:
    "Sonoma. This is the body of the sample post. It contains some information about the post.",
    postPublished: "2023-09-15T12:33:03.503139",
    postURL: "https://example.com/sample-post",
    postBody: "This is the body of the sample post. It contains some information about the post.",
    postThumbnailURL: "https://i.imgur.com/bgHfktp.jpeg",
    postFeatured: false,
    personID: 1,
    personName: "mani",
    personPublished: "October 17, 2023",
    personActorID: "mani01",
    personInstanceID: 123,
    personAvatar: "https://i.imgur.com/cflaISU.jpeg",
    personDisplayName: "Mani",
    personBio: "Just a sample user on this platform.",
    personBanner: "",
    communityID: 1,
    communityName: "SampleCommunity",
    communityTitle: "Welcome to the Sample Community",
    communityActorID: "https://lemmy.world/c/worldnews",
    communityInstanceID: 456,
    communityDescription:
    "This is a sample community description. It provides information about the community.",
    communityIcon: "https://example.com/community-icon.jpg",
    communityBanner: "https://example.com/community-banner.jpg",
    communityUpdated: "October 16, 2023",
    communitySubscribed: .subscribed,
    postScore: 42,
    postCommentCount: 10,
    upvotes: 30,
    downvotes: 12,
    postMyVote: 1,
    postHidden: false,
    postMinimised: true,
    sort: "Active",
    type: "All",
    filterKey: "sortAndTypeOnly"
  )
  let privateMessage = RealmPrivateMessage(
    messageID: 123,
    messageContent: "Hello, this is a placeholder message.",
    messageDeleted: false,
    messageRead: true,
    messagePublished: "2023-09-15T16:11:33.739267",
    messageApID: "abc123",
    messageIsLocal: true,
    creatorID: 456,
    creatorName: "John Doe",
    creatorAvatar: "https://example.com/john_avatar.jpg",
    creatorActorID: "https://lemmy.world/u/mani",
    recipientID: 789,
    recipientName: "Jane Smith",
    recipientAvatar: "https://example.com/jane_avatar.jpg",
    recipientActorID: "actor456"
  )
}

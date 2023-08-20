//
//  MockData.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import SwiftUI

enum MockData {
  static let kbinPostURL =
    "https://kbin.social/m/kbinMeta/t/86614/PSA-Upvote-is-not-an-upvote-like-you-are-used"
  static let kbinPostURL2 = "/m/kbinMeta/t/86614/PSA-Upvote-is-not-an-upvote-like-you-are-used"
  static let kbinPost = KbinPost(
    id: "entry-315569", title: "Posadist Star Trek is solid canon (hexbear.net)", user: "culpritus",
    timeAgo: "1 hour ago", upvotes: 48, downvotes: 1, previewImageUrl: "", commentsCount: 4,
    imageUrl:
      "https://media.kbin.social/media/52/33/52337e34b01f0aea5a6632c01f97ba90dc303bd0748281dfd89210e4e5330a0e.jpg",
    magazine: "memes",
    userObject: Optional(
      Lunar.KbinUser(
        username: "culpritus", avatarUrl: "", joined: "", reputationPoints: 0, browseUrl: "",
        followCount: 0)), instanceLink: Optional("hexbear.net"),
    postURL: "/m/memes@lemmy.ml/t/315569/Posadist-Star-Trek-is-solid-canon")
  static let kbinPostBody1 =
    "Like the title says, if you want to upvote something on KBin, you should use the Boost link, not the upvote button (Why? Don't know...). The upvote button doesn't seem to do much, but Boost accomplishes what Reddit's upvote did. So if you're looking to encourage a post, use the Boost link."

  static let lemmyPostBody = Optional(
    "I was interested in buying a Steam Deck... So my question is: are the rivals of the Steam Deck worth their price? Are really better than the Steam Deck (in terms of quality, screen, size)? Thank you for your opinion!"
  )
  //  static let mockPost = PostsModel(posts: [
  //    PostElement(
  //      post: PostObject(
  //        id: 2_222_222,
  //        name: "This is an example title used while creating the post row view in xcode",
  //        url: "https://lemmy.world/pictrs/image/7ae620b7-203e-43f3-b43f-030ad3beb629.png",
  //        creatorID: 316_097,
  //        communityID: 22036,
  //        removed: false,
  //        locked: false,
  //        published: "2023-07-07T23:47:15.923519Z",
  //        deleted: false,
  //        thumbnailURL: "https://i.imgur.com/F3LORSG.jpeg",
  //        apID: "https://lemmy.world/post/1161347",
  //        local: true,
  //        languageID: 37,
  //        featuredCommunity: false,
  //        featuredLocal: false,
  //        body: "[@ljdawson](https://lemmy.world/u/ljdawson) shared on Discord",
  //        updated: "2023-07-07T23:49:45.584798Z",
  //        embedTitle: nil,
  //        embedDescription: nil,
  //        embedVideoURL: nil
  //      ),
  //      creator: Creator(
  //        id: 316_097,
  //        name: "eco",
  //        displayName: nil,
  //        avatar: nil,
  //        banned: false,
  //        published: "2023-06-21T17:02:57.364033Z",
  //        actorID: "https://lemmy.world/u/eco",
  //        bio: nil,
  //        local: true,
  //        banner: nil,
  //        deleted: false,
  //        admin: false,
  //        botAccount: false,
  //        instanceID: 1,
  //        updated: nil,
  //        matrixUserID: nil
  //      ),
  //      community: Community(
  //        id: 22036,
  //        name: "syncforlemmy",
  //        title: "Sync for Lemmy",
  //        description: "ðŸ‘€",
  //        removed: false,
  //        published: "2023-06-20T10:21:37.000528Z",
  //        updated: nil,
  //        deleted: false,
  //        actorID: "https://lemmy.world/c/syncforlemmy",
  //        local: true,
  //        icon: nil,
  //        hidden: false,
  //        postingRestrictedToMods: false,
  //        instanceID: 1,
  //        banner: nil
  //      ),
  //      creatorBannedFromCommunity: false,
  //      counts: Counts(
  //        id: 254_871,
  //        postID: 2_222_222,
  //        comments: 189,
  //        score: 2180,
  //        upvotes: 2188,
  //        downvotes: 8,
  //        published: "2023-07-07T23:47:15.923519Z",
  //        newestCommentTimeNecro: "2023-07-08T14:53:06.765630Z",
  //        newestCommentTime: "2023-07-08T14:53:06.765630Z",
  //        featuredCommunity: false,
  //        featuredLocal: false,
  //        hotRank: 204,
  //        hotRankActive: 8999
  //      ),
  //      subscribed: .notSubscribed,
  //      saved: false,
  //      read: false,
  //      creatorBlocked: false,
  //      unreadComments: 189
  //    ),
  //    PostElement(
  //      post: PostObject(
  //        id: 1_111_111,
  //        name: "This is an example title used while creating the post row view in xcode",
  //        url: "https://lemmy.world/pictrs/image/7ae620b7-203e-43f3-b43f-030ad3beb629.png",
  //        creatorID: 316_097,
  //        communityID: 22036,
  //        removed: false,
  //        locked: false,
  //        published: "2023-07-07T23:47:15.923519Z",
  //        deleted: false,
  //        thumbnailURL: "https://i.imgur.com/F3LORSG.jpeg",
  //        apID: "https://lemmy.world/post/1161347",
  //        local: true,
  //        languageID: 37,
  //        featuredCommunity: false,
  //        featuredLocal: false,
  //        body: "[@ljdawson](https://lemmy.world/u/ljdawson) shared on Discord",
  //        updated: "2023-07-07T23:49:45.584798Z",
  //        embedTitle: nil,
  //        embedDescription: nil,
  //        embedVideoURL: nil
  //      ),
  //      creator: Creator(
  //        id: 316_097,
  //        name: "eco",
  //        displayName: nil,
  //        avatar: nil,
  //        banned: false,
  //        published: "2023-06-21T17:02:57.364033Z",
  //        actorID: "https://lemmy.world/u/eco",
  //        bio: nil,
  //        local: true,
  //        banner: nil,
  //        deleted: false,
  //        admin: false,
  //        botAccount: false,
  //        instanceID: 1,
  //        updated: nil,
  //        matrixUserID: nil
  //      ),
  //      community: Community(
  //        id: 22036,
  //        name: "syncforlemmy",
  //        title: "Sync for Lemmy",
  //        description: "ðŸ‘€",
  //        removed: false,
  //        published: "2023-06-20T10:21:37.000528Z",
  //        updated: nil,
  //        deleted: false,
  //        actorID: "https://lemmy.world/c/syncforlemmy",
  //        local: true,
  //        icon: nil,
  //        hidden: false,
  //        postingRestrictedToMods: false,
  //        instanceID: 1,
  //        banner: nil
  //      ),
  //      creatorBannedFromCommunity: false,
  //      counts: Counts(
  //        id: 254_871,
  //        postID: 2_014_053,
  //        comments: 189,
  //        score: 2180,
  //        upvotes: 2188,
  //        downvotes: 8,
  //        published: "2023-07-07T23:47:15.923519Z",
  //        newestCommentTimeNecro: "2023-07-08T14:53:06.765630Z",
  //        newestCommentTime: "2023-07-08T14:53:06.765630Z",
  //        featuredCommunity: false,
  //        featuredLocal: false,
  //        hotRank: 204,
  //        hotRankActive: 8999
  //      ),
  //      subscribed: .notSubscribed,
  //      saved: false,
  //      read: false,
  //      creatorBlocked: false,
  //      unreadComments: 189
  //    ),
  //  ])
  //  static let post = PostElement(
  //    post: PostObject(
  //      id: 1_161_347,
  //      name: "This is an example title used while creating the post row view in xcode",
  //      url: "https://lemmy.world/pictrs/image/7ae620b7-203e-43f3-b43f-030ad3beb629.png",
  //      creatorID: 316_097,
  //      communityID: 22036,
  //      removed: false,
  //      locked: false,
  //      published: "2023-07-07T23:47:15.923519Z",
  //      deleted: false,
  //      thumbnailURL: "https://i.imgur.com/F3LORSG.jpeg",
  //      apID: "https://lemmy.world/post/1161347",
  //      local: true,
  //      languageID: 37,
  //      featuredCommunity: false,
  //      featuredLocal: false,
  //      body: "[@ljdawson](https://lemmy.world/u/ljdawson) shared on Discord",
  //      updated: "2023-07-07T23:49:45.584798Z",
  //      embedTitle: nil,
  //      embedDescription: nil,
  //      embedVideoURL: nil
  //    ),
  //    creator: Creator(
  //      id: 316_097,
  //      name: "eco",
  //      displayName: nil,
  //      avatar: "",
  //      banned: false,
  //      published: "2023-06-21T17:02:57.364033Z",
  //      actorID: "https://lemmy.world/u/eco",
  //      bio: nil,
  //      local: true,
  //      banner: nil,
  //      deleted: false,
  //      admin: false,
  //      botAccount: false,
  //      instanceID: 1,
  //      updated: nil,
  //      matrixUserID: nil
  //    ),
  //    community: Community(
  //      id: 22036,
  //      name: "syncforlemmy",
  //      title: "Sync for Lemmy",
  //      description: "ðŸ‘€",
  //      removed: false,
  //      published: "2023-06-20T10:21:37.000528Z",
  //      updated: nil,
  //      deleted: false,
  //      actorID: "https://lemmy.world/c/syncforlemmy",
  //      local: true,
  //      icon: nil,
  //      hidden: false,
  //      postingRestrictedToMods: false,
  //      instanceID: 1,
  //      banner: nil
  //    ),
  //    creatorBannedFromCommunity: false,
  //    counts: Counts(
  //      id: 254_871,
  //      postID: 1_161_347,
  //      comments: 189,
  //      score: 2180,
  //      upvotes: 2188,
  //      downvotes: 8,
  //      published: "2023-07-07T23:47:15.923519Z",
  //      newestCommentTimeNecro: "2023-07-08T14:53:06.765630Z",
  //      newestCommentTime: "2023-07-08T14:53:06.765630Z",
  //      featuredCommunity: false,
  //      featuredLocal: false,
  //      hotRank: 204,
  //      hotRankActive: 8999
  //    ),
  //    subscribed: .notSubscribed,
  //    saved: false,
  //    read: false,
  //    creatorBlocked: false,
  //    unreadComments: 189
  //  )
  static let communityInfoView1 = SearchCommunityInfo(
    id: 9166, name: "RedditMigration", title: "RedditMigration",
    description: Optional(
      "Tracking the lastest news and numbers about the #RedditMigration to open, Fediverse-based alternatives, including #Kbin and #Lemmy To see latest reeddit blackout info, see here: https://reddark.untone.uk/"
    ), removed: false, published: "2023-06-11T16:49:31", updated: Optional("2023-08-04T20:35:31"),
    deleted: false, nsfw: false, actorID: "https://kbin.social/m/RedditMigration", local: false,
    icon: Optional(
      "https://media.kbin.social/media/18/45/1845eef07ed4f2e4d008c1c4035cdd40c812cd8d3b4aa7dd1c13f9f82e5722df.png"
    ),
    banner: "https://lemmy.world/pictrs/image/d470bf41-dfa9-419f-84b1-54c4008c9e09.png?format=webp",
    hidden: false, postingRestrictedToMods: false, instanceID: 257)

  static let communityInfoView2 = SearchCommunityInfo(
    id: 1120, name: "gitlab", title: "GitLab is open source software to collaborate on code. ",
    description: Optional(
      "GitLab is open source software to collaborate on code. Create projects and repositories, manage access and do code reviews.\n\n**Another great git community:**\n\n[GIT - Github, Gitea, Gitlabs. Everything git](https://lemmy.ml/c/everything_git)"
    ), removed: false, published: "2021-04-19T15:16:16.444716",
    updated: Optional("2021-04-19T16:15:27.136726"), deleted: false, nsfw: false,
    actorID: "https://lemmy.ml/c/gitlab", local: false,
    icon: Optional("https://lemmy.ml/pictrs/image/MfBKj2QzF0.png"),
    banner: Optional("https://lemmy.ml/pictrs/image/LV8mLLqMbT.png"), hidden: false,
    postingRestrictedToMods: false, instanceID: 3)

  static let communityInfoView3 = SearchCommunityInfo(
    id: 5502, name: "TechEnthusiasts", title: "Tech Enthusiasts Hub",
    description: Optional(
      "A community for all tech enthusiasts to discuss the latest trends in technology, gadgets, software, and more."
    ), removed: false, published: "2023-08-01T09:20:15", updated: Optional("2023-08-05T18:30:40"),
    deleted: false, nsfw: false, actorID: "https://techhub.social/c/TechEnthusiasts", local: true,
    icon: Optional(
      "https://techhub.social/media/77/92/77924d2e92a18d9575a3bb078645d22eb8e2154876fb8215d6cacee237666630.png"
    ),
    banner: Optional(
      "https://techhub.social/pictrs/image/d7e2979e-47f7-4d47-9b7d-cd157ca234f6.jpg"),
    hidden: false, postingRestrictedToMods: false, instanceID: 105)

  static let communityInfoView4 = SearchCommunityInfo(
    id: 7841, name: "TravelDiaries", title: "Travel Diaries",
    description: Optional(
      "Share your travel experiences, photos, and tips with fellow wanderers in this vibrant travel community."
    ), removed: false, published: "2023-07-20T14:05:22", updated: Optional("2023-08-02T10:45:18"),
    deleted: false, nsfw: false, actorID: "https://travelersworld.com/c/TravelDiaries", local: true,
    icon: Optional(
      "https://travelersworld.com/media/23/96/2396969f43207d00e456238f4288f406f71942e05d1c2083e243024c3001c25c.png"
    ),
    banner: Optional(
      "https://travelersworld.com/pictrs/image/a5a45c16-55b6-4ebc-9f1c-125127c1a1db.jpg"),
    hidden: false, postingRestrictedToMods: false, instanceID: 205)

  static let userInfoView1 = Creator(
    id: 125_358, name: "DarkGamer", displayName: Optional("DarkGamer"),
    avatar: Optional(
      "https://media.kbin.social/media/84/b3/84b39e92ca82a81627053e201b34e5bd7f3337100b9aa8c8b81aa03c3f309e1b.jpg"
    ), banned: false, published: "2023-06-14T22:52:08", actorID: "https://kbin.social/u/DarkGamer",
    bio: Optional("A man of leisure living in the present, waiting for the future."), local: false,
    banner: Optional(
      "https://media.kbin.social/media/0a/b8/0ab85953c2ae0ad635d8c234143e1a4801c3f280a2d9d992be1c2aff9e28f384.jpg"
    ), deleted: false, admin: false, botAccount: false, instanceID: 257, updated: nil,
    matrixUserID: nil)

  static let userInfoView2 = Creator(
    id: 456_789, name: "CodingNinja", displayName: Optional("CodingNinja"),
    avatar: Optional(
      "https://techhub.social/media/14/25/14257a167f847cb566633e0b8a36e6db9d694299127977065222e5d7e2e5703a.jpg"
    ), banned: false, published: "2023-08-02T18:10:37",
    actorID: "https://techhub.social/u/CodingNinja",
    bio: Optional(
      "A passionate coder exploring the realms of programming, AI, and machine learning."),
    local: true,
    banner: Optional(
      "https://techhub.social/media/c6/9d/c69db24f7ff2a82630c70f76efc0a312e6c57c1e9e3e5dbf6f91eeab9caac5b8.jpg"
    ), deleted: false, admin: false, botAccount: false, instanceID: 105, updated: nil,
    matrixUserID: nil)

  static let userInfoView3 = Creator(
    id: 987_654, name: "Bookworm_27", displayName: Optional("Bookworm_27"),
    avatar: Optional(
      "https://travelersworld.com/media/39/1e/391e4c07c13b4b87197065a8e9eb7f60485dd08c0a8e788a7ad6c82473e7a7be.jpg"
    ), banned: false, published: "2023-07-25T12:30:55",
    actorID: "https://travelersworld.com/u/Bookworm_27",
    bio: Optional(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Aliquet bibendum enim facilisis gravida. Tincidunt ornare massa eget egestas purus viverra. Non sodales neque sodales ut etiam sit amet nisl purus. Sit amet consectetur adipiscing elit pellentesque habitant morbi. Sed risus pretium quam vulputate dignissim suspendisse in est. Lobortis scelerisque fermentum dui faucibus. Tincidunt vitae semper quis lectus nulla at volutpat. Velit euismod in pellentesque massa placerat duis ultricies. Penatibus et magnis dis parturient montes nascetur. Tincidunt vitae semper quis lectus. Aliquam sem fringilla ut morbi tincidunt augue interdum velit euismod. Urna neque viverra justo nec ultrices dui. At varius vel pharetra vel turpis nunc. Porttitor eget dolor morbi non arcu risus quis varius quam. Adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Nisi quis eleifend quam adipiscing vitae proin sagittis. Sapien pellentesque habitant morbi tristique. Nisi vitae suscipit tellus mauris a diam maecenas sed enim. Congue nisi vitae suscipit tellus mauris. Dui sapien eget mi proin sed libero enim. Arcu cursus euismod quis viverra nibh cras. Arcu ac tortor dignissim convallis aenean et tortor at risus. Orci sagittis eu volutpat odio facilisis. Nulla facilisi etiam dignissim diam quis. Donec enim diam vulputate ut pharetra sit amet aliquam id. Mauris vitae ultricies leo integer malesuada nunc vel risus commodo. Pellentesque habitant morbi tristique senectus et netus et malesuada."
    ), local: true,
    banner: Optional(
      "https://travelersworld.com/media/80/23/8023bbab2d1a4d1c3b6e11401259b2df6497632e387c69cda7c74b1e41b9ce00.jpg"
    ), deleted: false, admin: false, botAccount: false, instanceID: 205, updated: nil,
    matrixUserID: nil)

  static let userInfoView4 = Creator(
    id: 650_713, name: "maniel", displayName: nil,
    avatar: Optional("https://lemmy.ml/pictrs/image/3c00cbaa-f2d4-4b16-88bf-2438db3ab9c4.jpeg"),
    banned: false, published: "2023-06-07T09:24:31.398108", actorID: "https://lemmy.ml/u/maniel",
    bio: nil, local: true, banner: nil, deleted: false, admin: false, botAccount: false,
    instanceID: 394, updated: nil, matrixUserID: nil)

  static let commentsViewPostTitle1 =
    "Lemmy.world active users is tapering off while other servers are gaining serious traction."
  static let commentsViewThumbnailURL1 =
    "https://www.wallpapers13.com/wp-content/uploads/2015/12/Nature-Lake-Bled.-Desktop-background-image-1680x1050.jpg"
  static let commentsViewPostBody1 = """
    I noticed my feed on Lemmy was pretty dry today, even for Lemmy. Took me a while to realize lemmy.ml has been going up and down all morning
    """
  static let postElement = PostElement(
    image: nil,
    post: Lunar.PostObject(
      id: 3_389_331,
      name: "France wants your browser to censor the web, and Mozilla is petitioning against it",
      url: Optional(
        "https://foundation.mozilla.org/en/campaigns/sign-our-petition-to-stop-france-from-forcing-browsers-like-mozillas-firefox-to-censor-websites/"
      ), creatorID: 645391, communityID: 2478, removed: false, locked: false,
      published: "2023-08-18T14:46:39.367843", deleted: false,
      thumbnailURL: Optional(
        "https://lemmy.world/pictrs/image/fd7c305a-5c7b-454b-89f4-e156d509979e.png"),
      apID: "https://lemmy.world/post/3389331", local: true, languageID: 37,
      featuredCommunity: false, featuredLocal: false,
      body: Optional(
        "More context: https://blog.mozilla.org/netpolicy/2023/06/26/france-browser-website-blocking/"
      ), updated: nil,
      embedTitle: Optional(
        "Sign our petition to stop France from forcing browsers like Mozilla\'s Firefox to censor websites"
      ),
      embedDescription: Optional(
        "The French government is considering a law that would require web browsers – like Mozilla\'s Firefox – to block websites chosen by the government."
      ), embedVideoURL: nil),
    creator: Lunar.Creator(
      id: 645391, name: "AccidentalLemming", displayName: nil, avatar: nil, banned: false,
      published: "2023-07-02T13:50:38.748078", actorID: "https://lemmy.world/u/AccidentalLemming",
      bio: nil, local: true, banner: nil, deleted: false, admin: false, botAccount: false,
      instanceID: 1, updated: nil, matrixUserID: nil),
    community: Lunar.Community(
      id: 2478, name: "technology", title: "Technology",
      description: Optional(
        "This is a [most excellent](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN3N0NmhuODNib3d3Nzg0OHU2bTFqMXAzNW42Y2JsOTVmenNsNG8ycSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/l46CDHTqbmnGZyxKo/giphy.gif) place for technology news and articles.\n \n---\n \n## Our Rules\n \n---\n \n1. Follow the [lemmy.world rules.](https://mastodon.world/about) \n2. Only tech related content.\n3. Be [excellent to each another!](https://www.youtube.com/watch?v=rph_1DODXDU)\n4. Mod approved content bots can post up to 10 articles per day.\n5. Threads asking for personal tech support may be deleted.\n6. Politics threads may be removed.\n7. No memes allowed as posts, OK to post as comments.\n8. Only approved bots from the list below, to ask if your bot can be added please contact us.\n9. Check for duplicates before posting, duplicates may be removed\n \n---\n \n## Approved Bots\n \n---\n \n- [@L4s@lemmy.world](https://lemmy.world/u/L4s) \n- [@autotldr@lemmings.world](https://lemmings.world/u/autotldr) \n- [@PipedLinkBot@feddit.rocks](https://feddit.rocks/u/PipedLinkBot) "
      ), removed: false, published: "2023-06-11T02:16:17.173483",
      updated: Optional("2023-08-18T03:42:50.251018"), deleted: false,
      actorID: "https://lemmy.world/c/technology", local: true,
      icon: Optional("https://lemmy.world/pictrs/image/06660c76-9219-486e-a146-27b69dcac8ce.png"),
      hidden: false, postingRestrictedToMods: false, instanceID: 1, banner: nil),
    creatorBannedFromCommunity: false,
    counts: Lunar.Counts(
      id: 549580, postID: 3_389_331, comments: 207, score: 1761, upvotes: 1774, downvotes: 13,
      published: "2023-08-18T14:46:39.367843", newestCommentTimeNecro: "2023-08-19T16:19:35.968452",
      newestCommentTime: "2023-08-19T16:19:35.968452", featuredCommunity: false,
      featuredLocal: false, hotRank: 82, hotRankActive: 8019),
    subscribed: Lunar.SubscribedState.notSubscribed, saved: false, read: false,
    creatorBlocked: false, unreadComments: 207, myVote: nil)

  //  static let commentElement = CommentElement(comment: Lunar.CommentsListObject(id: 957028, creatorID: 6277435, postID: 7139973, content: "Watching the drama unfold on lemmy.world and all the freeze peach warriors going ape shit over there has me grateful for this little corner. ", removed: false, published: "2023-08-15T16:36:54.377463", deleted: false, apID: "https://beehaw.org/comment/957028", local: true, path: "0.957028", distinguished: false, languageID: 37), creator: Lunar.CommentsListCreator(id: 6277435, name: "acastcandream", banned: false, published: "2023-08-03T13:29:25.016098", actorID: "https://beehaw.org/u/acastcandream", local: true, deleted: false, admin: false, botAccount: false, instanceID: 664, displayName: nil, avatar: nil, banner: nil, bio: nil), post: PostElement(id: 7139973, name: Optional("how\'s your week going, Beehaw"), body: Optional("we\'re so back (but i will be making a separate post for my circumstances)"), creatorID: 8, communityID: 16542, removed: false, locked: false, published: "2023-08-14T14:57:26.612558", updated: nil, deleted: false, nsfw: false, apID: "https://beehaw.org/post/7139973", local: true, languageID: 37, featuredCommunity: true, featuredLocal: true), community: Lunar.CommentsListCommunity(id: 16542, name: "chat", title: "Chat", description: Optional("Relaxed section for discussion and debate that doesn\'t fit anywhere else. Whether it\'s advice, how your week is going, a link that\'s at the back of your mind, or something like that, it can likely go here.\n\n---\n\nSubcommunities on Beehaw:\n- [AskBeehaw](https://beehaw.org/c/askbeehaw)\n\n---\n\nThis community\'s icon was made by Aaron Schneider, under the [CC-BY-NC-SA 4.0 license](https://creativecommons.org/licenses/by-nc-sa/4.0/)."), removed: Optional(false), published: "2023-02-09T17:49:43.318904", updated: Optional("2023-07-08T02:19:55.340768"), deleted: false, nsfw: false, actorID: "https://beehaw.org/c/chat", local: Optional(true), icon: Optional("https://beehaw.org/pictrs/image/bcae6839-244a-4162-a988-42ee46909013.png"), banner: nil, hidden: Optional(false), postingRestrictedToMods: Optional(false), instanceID: 664), counts: Lunar.CommentsListCounts(id: 807166, commentID: 957028, score: 2, upvotes: 2, downvotes: 0, published: "2023-08-15T16:36:54.377463", childCount: 0, hotRank: 1036), creatorBannedFromCommunity: false, subscribed: Lunar.CommentSubscribed.notSubscribed, saved: false, creatorBlocked: false)

  static let searchUserRow = [
    Lunar.UserElement(
      person: Lunar.Creator(
        id: 44936, name: "manitcor", displayName: Optional("manitcor"),
        avatar: Optional(
          "https://lemmy.intai.tech/pictrs/image/354e199f-c2b7-4da5-9a38-a7b1459adb25.png"),
        banned: false, published: "2023-06-11T04:31:18.917668",
        actorID: "https://lemmy.intai.tech/u/manitcor",
        bio: Optional(
          "It\'s your internet, own it.\n\n[Fediverse Welcome Kit](https://lemmy.intai.tech/post/30829)\n\n[Topical Instances](https://lemmy.intai.tech/post/3511)\n\n[ML Community Web](https://lemmy.intai.tech/post/2182)\n\n[AI Bots](https://lemmy.intai.tech/post/2484)"
        ), local: false,
        banner: Optional(
          "https://lemmy.intai.tech/pictrs/image/dd8f1ef3-2624-498f-b078-375c2f33f493.png"),
        deleted: false, admin: false, botAccount: false, instanceID: 838, updated: nil,
        matrixUserID: nil),
      counts: Lunar.SearchUserCounts(
        id: 22904, personID: 44936, postCount: 698, postScore: 1425, commentCount: 921,
        commentScore: 996))
  ]

  static let searchCommunitiesResults = [
    Lunar.CommunityElement(
      community: Lunar.CommunityObject(
        id: 134975, name: "nvidia", title: "The NVIDIA Subreddit", removed: false,
        published: "2023-07-18T17:09:25.318559", deleted: false,
        actorID: "https://zerobytes.monster/c/nvidia", local: false, hidden: false,
        postingRestrictedToMods: true, instanceID: 2156,
        description: Optional(
          "A place for everything NVIDIA, come talk about news, drivers, rumors, GPUs, the industry, show-off your build and more. This Subreddit is..."
        ), updated: nil, icon: nil, banner: nil), subscribed: Lunar.SubscribedState.notSubscribed,
      blocked: false,
      counts: Lunar.CountsObject(
        id: 31667, communityID: 134975, subscribers: 1, posts: 0, comments: 0,
        published: "2023-07-18T17:09:25.318559", usersActiveDay: 0, usersActiveWeek: 0,
        usersActiveMonth: 0, usersActiveHalfYear: 0, hotRank: 0))
  ]
}

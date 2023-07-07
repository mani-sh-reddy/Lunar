let post = PostObject(
    id: 1138980,
    name: "The Internet is a wild place",
    url: "https://lemmy.world/pictrs/image/855afd36-47d0-4365-a364-0bfa691af59b.jpeg",
    creatorID: 654617,
    communityID: 13,
    removed: false,
    locked: false,
    published: "2023-07-07T14:07:05.807679",
    deleted: false,
    thumbnailURL: "https://lemmy.world/pictrs/image/f317e579-6553-43b2-be7f-9be963584c58.jpeg",
    apID: "https://lemmy.world/post/1138980",
    local: true,
    languageID: 0,
    featuredCommunity: false,
    featuredLocal: false,
    body: "",
    updated: "",
    embedTitle: "",
    embedDescription: "",
    embedVideoURL: ""
)

let creator = Creator(
    id: 654617, name: "Scarronline", displayName: "", avatar: "", banned: false, published: "2023-07-02T18:40:49.380602", actorID: "https://lemmy.world/u/Scarronline", bio: "", local: true, banner: "", deleted: false, admin: false, botAccount: false, instanceID: 1, updated: "", matrixUserID: ""
)

let community = Community(
    id: 4156, name: "youshouldknow", title: "You Should Know", description: "YSK stands for you should know", removed: false, published: "2023-06-12T05:16:19.475890", updated: "2023-07-06T21:54:37.166556", deleted: false, actorID: "https://lemmy.world/c/youshouldknow", local: true, icon: "https://lemmy.world/pictrs/image/13c64711-f6bb-429b-a54a-4e65e4e37046.png", hidden: false, postingRestrictedToMods: false, instanceID: 1, banner: "https://lemmy.world/pictrs/image/d470bf41-dfa9-419f-84b1-54c4008c9e09.png"
)

let counts = Counts(
    id: 249734,
    postID: 1138329,
    comments: 9,
    score: 106,
    upvotes: 106,
    downvotes: 0,
    published: "2023-07-07T13:54:33.467924",
    newestCommentTimeNecro: "2023-07-07T14:33:00",
    newestCommentTime: "2023-07-07T14:33:00",
    featuredCommunity: false,
    featuredLocal: false,
    hotRank: 3535,
    hotRankActive: 5599
)

let allPosts = PostElement(
    post: post,
    creator: creator,
    community: community,
    creatorBannedFromCommunity: false,
    counts: counts,
    subscribed: Subscribed(rawValue: "NotSubscribed")!,
    saved: false,
    read: false,
    creatorBlocked: false,
    unreadComments: 9
)

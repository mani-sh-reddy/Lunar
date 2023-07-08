//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @ObservedObject var allPosts = AllPostsListLoader()
    var feedType: String

    var body: some View {
        List {
            ForEach(allPosts.posts, id: \.post.id) { post in
                Section(footer: PostRowFooterView(post: post)) {
                    NavigationLink {
                        Link(String(post.post.url ?? "Link"), destination: URL(string: post.post.url ?? "") ?? URL(string: "lemmy.world")!)
                        CommentsListView(postId: post.post.id)
                    } label: {
                        VStack {
                            PostRowView(post: post)
                        }
                    }
                }
                .onAppear {
                    let thumbnailURLs = allPosts.thumbnailURLsStrings.compactMap { URL(string: $0) }
                    let prefetcher = ImagePrefetcher(urls: thumbnailURLs) {
                        _, _, _ in
                    }
                    prefetcher.start()
                }
            }
        }
        .navigationTitle(feedType)
        .listStyle(.grouped)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let loader = AllPostsListLoader()
        loader.posts = [
            PostElement(
                post: PostObject(id: 1, name: "Example Post", url: "https://example.com", creatorID: 1, communityID: 1, removed: false, locked: false, published: "2023-07-06T12:34:56Z", deleted: false, thumbnailURL: "https://example.com/thumbnail.jpg", apID: "exampleID", local: true, languageID: 1, featuredCommunity: false, featuredLocal: false, body: "This is an example post", updated: nil, embedTitle: nil, embedDescription: nil, embedVideoURL: nil),
                creator: Creator(id: 1, name: "JohnDoe", displayName: "John Doe", avatar: nil, banned: false, published: "2023-07-06T12:34:56Z", actorID: "johnDoeActorID", bio: "I'm a user", local: true, banner: nil, deleted: false, admin: false, botAccount: false, instanceID: 1, updated: nil, matrixUserID: nil),
                community: Community(id: 1, name: "ExampleCommunity", title: "Example Community", description: "This is an example community", removed: false, published: "2023-07-06T12:34:56Z", updated: nil, deleted: false, actorID: "exampleCommunityActorID", local: true, icon: nil, hidden: false, postingRestrictedToMods: false, instanceID: 1, banner: nil),
                creatorBannedFromCommunity: false,
                counts: Counts(id: 1, postID: 1, comments: 5, score: 10, upvotes: 15, downvotes: 5, published: "2023-07-06T12:34:56Z", newestCommentTimeNecro: "2023-07-06T12:34:56Z", newestCommentTime: "2023-07-06T12:34:56Z", featuredCommunity: false, featuredLocal: false, hotRank: 1, hotRankActive: 1), subscribed: .notSubscribed, saved: false, read: false, creatorBlocked: false, unreadComments: 3
            )
        ]

        let onePostLoader = AllPostsListLoader()
        onePostLoader.posts = Array(loader.posts.prefix(1))

        return PostsListView(allPosts: onePostLoader, feedType: "All")
    }
}

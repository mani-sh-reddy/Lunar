//
//  PostsListView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @StateObject var postFetcher: PostFetcher
    var prop: [String: String]?
    @State var communityID: Int
    var communityHeading: String = "Feed"

    var body: some View {
        ScrollViewReader { _ in
            List {
                /// workaround to fix non unique post IDs
                ForEach(Array(postFetcher.posts.enumerated()), id: \.element.post.id) { index, post in
                    ZStack {
                        PostRowView(post: post)
                        NavigationLink(destination:
                                        CommentsView(commentFetcher: CommentFetcher(postID: post.post.id), postID: post.post.id, postTitle: post.post.name, thumbnailURL: post.post.thumbnailURL ?? "")
                        ) {
                            EmptyView()
                        }.opacity(0)
                    }
                    .onAppear{
                        postFetcher.loadMoreContentIfNeeded(currentItem: post)
                    }
                    .accentColor(Color.primary)
                }
                if postFetcher.isLoading {
                    ProgressView()
                }
                    
            }.refreshable{
                postFetcher.refreshContent()
            }
            .listStyle(.plain)
            .navigationTitle(prop?["title"] ?? communityHeading)
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let postFetcher = PostFetcher(communityID: 0, prop: [:])
        PostsListView(postFetcher: postFetcher, prop: [:], communityID: 0)
    }
}

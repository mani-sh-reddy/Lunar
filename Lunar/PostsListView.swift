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
    var title: String
    

    var body: some View {
        ScrollViewReader { _ in

            List {
                ForEach(postFetcher.posts, id: \.post.id) { post in
                    ZStack {
                        PostRowView(post: post)
                        NavigationLink(destination:
                                        CommentsView(commentFetcher: CommentFetcher(postID: post.post.id), postID: post.post.id, postTitle: post.post.name, thumbnailURL: post.post.thumbnailURL ?? "", postBody: post.post.body ?? "")
                        ) {
                            EmptyView().frame(height: 0)
                        }.opacity(0)
                    }
                    .task {
                        postFetcher.loadMoreContentIfNeeded(currentItem: post)
                    }
                    .accentColor(Color.primary)
                }
                if postFetcher.isLoading {
                    ProgressView()
                }
            }
            .refreshable {
                await postFetcher.refreshContent()
            }
            .listStyle(.plain)
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let postFetcher = PostFetcher(communityID: 0, prop: [:])
        PostsListView(postFetcher: postFetcher, prop: [:], communityID: 0, title: "All")
    }
}

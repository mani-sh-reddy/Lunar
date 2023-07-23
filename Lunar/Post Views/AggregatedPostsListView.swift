//
//  PostsListView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct AggregatedPostsListView: View {
    @StateObject var aggregatedPostsFetcher: AggregatedPostsFetcher
    var title: String

    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(aggregatedPostsFetcher.posts, id: \.post.id) { post in
                    Section {
                        ZStack {
                            PostRowView(post: post)
                            NavigationLink(destination: CommentsView(
                                commentsFetcher: CommentsFetcher(
                                    postID: post.post.id,
                                    sortParameter: "Top",
                                    typeParameter: "All"
                                ),
                                postID: post.post.id,
                                postTitle: post.post.name,
                                thumbnailURL: post.post.thumbnailURL,
                                postBody: post.post.body
                            )) {
                                EmptyView()
                                    .frame(height: 0)
                            }
                            .opacity(0)
                        }
                        .task {
                            aggregatedPostsFetcher.loadMoreContentIfNeeded(currentItem: post)
                        }
                        .accentColor(Color.primary)
                    }
                }
                if aggregatedPostsFetcher.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle(title)
            .listStyle(.grouped)
            .refreshable {
                await aggregatedPostsFetcher.refreshContent()
            }
        }
    }
}

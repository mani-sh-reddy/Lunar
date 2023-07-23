//
//  CommunitySpecificPostsListView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct CommunitySpecificPostsListView: View {
    @StateObject var communitySpecificPostsFetcher: CommunitySpecificPostsFetcher
    var prop: [String: String]?
    @State var communityID: Int
    var title: String

    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(communitySpecificPostsFetcher.posts, id: \.post.id) { post in
                    let commentsFetcher = CommentsFetcher(
                        postID: post.post.id,
                        // TODO: make these user changeable parameters
                        sortParameter: "Top",
                        typeParameter: "All"
                    )

                    let destination = CommentsView(
                        commentsFetcher: commentsFetcher,
                        postID: post.post.id,
                        postTitle: post.post.name,
                        thumbnailURL: post.post.thumbnailURL,
                        postBody: post.post.body
                    )

                    Section {
                        ZStack {
                            PostRowView(post: post)
                            NavigationLink(destination: destination) {
                                EmptyView()
                                    .frame(height: 0)
                            }
                            .opacity(0)
                        }
                        .task {
                            communitySpecificPostsFetcher.loadMoreContentIfNeeded(currentItem: post)
                        }
                        .accentColor(Color.primary)
                    }
                }
                if communitySpecificPostsFetcher.isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle(title)
            .listStyle(.grouped)
            .refreshable {
                await communitySpecificPostsFetcher.refreshContent()
            }
        }
    }
}

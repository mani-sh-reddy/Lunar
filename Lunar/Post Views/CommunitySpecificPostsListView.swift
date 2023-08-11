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
    @State var communityID: Int
    var prop: [String: String] = [:]
    var title: String
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(communitySpecificPostsFetcher.posts, id: \.post.id) { post in
                    Section {
                        ZStack {
                            PostRowView(post: post)
                            NavigationLink(
                                destination: CommentsView(
                                    commentsFetcher: CommentsFetcher(
                                        postID: post.post.id,
                                        sortParameter: "Top",
                                        typeParameter: "All"
                                    ),
                                    postID: post.post.id,
                                    postTitle: post.post.name,
                                    thumbnailURL: post.post.thumbnailURL,
                                    postBody: post.post.body
                                )
                            ) {
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
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.grouped)
            .refreshable {
                await communitySpecificPostsFetcher.refreshContent()
            }
        }
    }
}

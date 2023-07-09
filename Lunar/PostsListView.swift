//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @StateObject var postsListFetcher = PostsListFetcher()
    @State var viewTitle: String
    var feedType: String = ""
    var feedSort: String
    var communityId: Int = 0
    @State var isModal: Bool = false

    var body: some View {
        ScrollView {
            ForEach(postsListFetcher.posts, id: \.post.id) { post in
                //                    NavigationLink {
                //                        Link(String(post.post.url ?? "Link"), destination: URL(string: post.post.url ?? "") ?? URL(string: "lemmy.world")!)
                //                        CommentsListView(postId: post.post.id)
                //                    } label: {

                NavigationLink(destination: CommentsListView(postId: post.post.id, postTitle: post.post.name)) {
                    PostRowView(post: post)
                }
                .accentColor(Color.primary)

                VStack(spacing: 0) {
                    Divider()
                    Rectangle()
                        .fill(Color.gray).opacity(0.2)
                        .frame(height: 25)
                        .edgesIgnoringSafeArea(.horizontal)
                    Divider()
                }
                .padding(.horizontal, -100)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .overlay(Group {
            if !postsListFetcher.isLoaded {
                ProgressView("Fetching")
                    .frame(width: 100)
            }
        })
        .task {
            let baseURL = "https://lemmy.world/api/v3/post/list?sort=\(feedSort)&limit=50&"
            let nonSpecificUrlPrefix = "type_=\(feedType)"
            let communitySpecificUrlPrefix = "community_id=\(communityId)"

            let endpoint = "\(baseURL)\(communityId == 0 ? nonSpecificUrlPrefix : communitySpecificUrlPrefix)"
            postsListFetcher.fetch(endpoint: endpoint)
        }
        .navigationTitle(viewTitle)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
//        let mockPost = MockPost.mockPost

        PostsListView(postsListFetcher: PostsListFetcher(), viewTitle: "MOCKDATA", feedType: "All", feedSort: "Active")
    }
}

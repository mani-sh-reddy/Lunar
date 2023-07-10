//
//  PostsListView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @StateObject var posts = PostsListFetcher()
    var props: [String: String]?
    var communityId: Int = 0
    var communityHeading: String = "Feed"
    @State private var hasAppearedOnce = false

    var body: some View {
        ScrollView {
            ForEach(posts.posts, id: \.post.id) { post in

                VStack(spacing: 0) {
                    Divider().background(Color.gray)
                    Rectangle()
                        .fill(Color.gray).opacity(0.2)
                        .frame(height: 15)
                        .edgesIgnoringSafeArea(.horizontal)
                    Divider().background(Color.gray)
                }.opacity(0.5)
                    .padding(.horizontal, -100)

                //                    NavigationLink {
                //                        Link(String(post.post.url ?? "Link"), destination: URL(string: post.post.url ?? "") ?? URL(string: "lemmy.world")!)
                //                        CommentsListView(postId: post.post.id)
                //                    } label: {

                NavigationLink(destination: CommentsListView(postId: post.post.id, postTitle: post.post.name)) {
                    PostRowView(post: post)
                }
                .accentColor(Color.primary)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
        }
        .overlay(Group {
            if !posts.isLoaded {
                ProgressView("Fetching")
                    .frame(width: 100)
            }
        })
        .refreshable {
            let baseURL = "https://lemmy.world/api/v3/post/list?sort=\(props?["sort"] ?? "Active")&limit=50&"
            let nonSpecificUrlPrefix = "type_=\(props?["type"] ?? "Local")"
            let communitySpecificUrlPrefix = "community_id=\(communityId)"
            var prefixURL = ""
            print(communityId)
            if communityId == 0 {
                prefixURL = nonSpecificUrlPrefix
            } else {
                prefixURL = communitySpecificUrlPrefix
            }

            let endpoint = "\(baseURL)\(prefixURL)"
            posts.fetch(endpoint: endpoint)
        }
        .onAppear {
            guard !hasAppearedOnce else { return }
            hasAppearedOnce = true
            let baseURL = "https://lemmy.world/api/v3/post/list?sort=\(props?["sort"] ?? "Active")&limit=50&"
            let nonSpecificUrlPrefix = "type_=\(props?["type"] ?? "Local")"
            let communitySpecificUrlPrefix = "community_id=\(communityId)"
            var prefixURL = ""
            print(communityId)
            if communityId == 0 {
                prefixURL = nonSpecificUrlPrefix
            } else {
                prefixURL = communitySpecificUrlPrefix
            }

            let endpoint = "\(baseURL)\(prefixURL)"
            posts.fetch(endpoint: endpoint)
        }
        .navigationTitle(props?["title"] ?? communityHeading)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var props: [String: String] = props
    static var previews: some View {
//        let mockPost = MockPost.mockPost

        PostsListView(props: props)
    }
}

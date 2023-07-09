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

    var body: some View {
        List {
            ForEach(postsListFetcher.posts, id: \.post.id) { post in
                Section {
                    NavigationLink {
                        Link(String(post.post.url ?? "Link"), destination: URL(string: post.post.url ?? "") ?? URL(string: "lemmy.world")!)
                        CommentsListView(postId: post.post.id)
                    } label: {
                        VStack {
                            PostRowView(post: post)
                        }
                    }
                }
            }
        }
        .task {
            let baseURL = "https://lemmy.world/api/v3/post/list?sort=\(feedSort)&limit=50&"
            let nonSpecificUrlPrefix = "type_=\(feedType)"
            let communitySpecificUrlPrefix = "community_id=\(communityId)"

            let endpoint = "\(baseURL)\(communityId == 0 ? nonSpecificUrlPrefix : communitySpecificUrlPrefix)"
            postsListFetcher.fetch(endpoint: endpoint)
        }
        .navigationTitle(viewTitle)
        .listStyle(.grouped)
        .overlay(Group {
            if !postsListFetcher.isLoaded {
                ProgressView("Fetching")
            }
        })
    }
}

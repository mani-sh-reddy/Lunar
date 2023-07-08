//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @StateObject private var fetcher = Fetcher<PostsModel>()
    @State var postsModel = PostsModel(posts: [])
    @State var viewTitle: String
    var feedType: String = ""
    var feedSort: String
    var communityId: Int = 0

    var body: some View {
        List {
            ForEach(fetcher.result?.posts ?? [], id: \.post.id) { post in
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
        .onAppear {
            fetchPostsList(feedType: feedType, feedSort: feedSort, communityId: communityId)
        }

        .navigationTitle(viewTitle)
        .listStyle(.grouped)
    }

    func fetchPostsList(
        feedType: String,
        feedSort: String,
        communityId: Int
    ) {
        let baseURL = "https://lemmy.world/api/v3/post/list?sort=\(feedSort)&limit=50&"
        let nonSpecificUrlPrefix = "type_=\(feedType)"
        let communitySpecificUrlPrefix = "community_id=\(communityId)"

        let urlString = "\(baseURL)\(communityId == 0 ? nonSpecificUrlPrefix : communitySpecificUrlPrefix)"
        fetcher.fetchResponse(urlString: urlString)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPost = MockPost.mockPost

        PostsListView(postsModel: mockPost, viewTitle: "MOCKDATA", feedType: "All", feedSort: "Active")
    }
}

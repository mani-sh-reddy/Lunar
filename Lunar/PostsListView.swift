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
    var feedType: String
    var feedSort: String

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
            fetchPostsList(feedType: feedType, feedSort: feedSort)
        }

        .navigationTitle(feedType)
        .listStyle(.grouped)
    }

    func fetchPostsList(feedType: String, feedSort: String) {
        let thumbnailURLs = postsModel.thumbnailURLs.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(urls: thumbnailURLs) {
            _, _, _ in
        }
        prefetcher.start()

        let urlString = "https://lemmy.world/api/v3/post/list?type_=\(feedType)&sort=\(feedSort)&limit=50"
        fetcher.fetchResponse(urlString: urlString)
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockPost = MockPost.mockPost

        PostsListView(postsModel: mockPost, feedType: "All", feedSort: "Active")
    }
}

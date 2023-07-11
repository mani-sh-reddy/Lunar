//
//  PostsListView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsListView: View {
    @StateObject var items: PostsListFetcher
    var prop: [String: String]?
    @State var communityID: Int
    var communityHeading: String = "Feed"
    @State private var hasAppearedOnce = false

    var body: some View {
        ScrollViewReader { value in
            List {
                ForEach(items.items, id: \.post.id) { post in

                    // MARK: - navigationview hide arrow workaround

                    ZStack {
                        PostRowView(post: post)
                        NavigationLink(destination: CommentsListView(postId: post.post.id, postTitle: post.post.name)) {
                            EmptyView()
                        }.opacity(0)
                    }

                    // MARK: -

//                    NavigationLink(destination: CommentsListView(postId: post.post.id, postTitle: post.post.name)) {
//                        PostRowView(post: post)
//                    }
                    .onAppear {
                        items.loadMoreContentIfNeeded(currentItem: post)
                    }
                    .accentColor(Color.primary)
                }

                if items.isLoadingPage {
                    ProgressView()
                }
            }
            .listStyle(.plain)
            .navigationTitle(prop?["title"] ?? communityHeading)
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        let items = PostsListFetcher(communityID: 0, prop: [:])
        PostsListView(items: items, prop: [:], communityID: 0)
    }
}

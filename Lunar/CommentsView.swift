//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Kingfisher
import SwiftUI

struct CommentsView: View {
    @StateObject var commentFetcher: CommentFetcher
    @State var postID: Int
    var postTitle: String
    var thumbnailURL: String

    var body: some View {
        ScrollViewReader { _ in
            VStack {
                List {
                    Text(postTitle).font(.title2).bold()

                    if thumbnailURL == "" {
                        EmptyView()
                    } else {
                        InPostThumbnailView(thumbnailURL: thumbnailURL)
                    }

                    ForEach(commentFetcher.comments, id: \.comment.id) { comment in
                        Text(String(comment.comment.content))
                            .onAppear {
                                commentFetcher.loadMoreContentIfNeeded(currentItem: comment)
                            }
                            .accentColor(Color.primary)
                    }
                    if commentFetcher.isLoading {
                        ProgressView()
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "globe.americas.fill") }
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let commentFetcher = CommentFetcher(postID: 1442451)

        CommentsView(commentFetcher: commentFetcher, postID: 1442451, postTitle: "Lemmy.world active users is tapering off while other servers are gaining serious traction.", thumbnailURL: "https://www.wallpapers13.com/wp-content/uploads/2015/12/Nature-Lake-Bled.-Desktop-background-image-1680x1050.jpg")
    }
}

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
    var postBody: String

    var body: some View {
        ScrollViewReader { _ in
            VStack {
                List {
                    Text(postTitle).font(.title).bold()

                    if thumbnailURL == "" {
                        EmptyView()
                    } else {
                        InPostThumbnailView(thumbnailURL: thumbnailURL)
                    }

                    if postBody == "" {
                        EmptyView()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous).foregroundStyle(.regularMaterial)
                            Text(postBody).padding(10).multilineTextAlignment(.leading)
                        }
                        .padding(.bottom, 20)
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
                .refreshable {
                    await commentFetcher.refreshContent()
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "chart.line.uptrend.xyaxis") }
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let commentFetcher = CommentFetcher(postID: 1442451)

        CommentsView(commentFetcher: commentFetcher, postID: 1442451, postTitle: "Lemmy.world active users is tapering off while other servers are gaining serious traction.", thumbnailURL: "https://www.wallpapers13.com/wp-content/uploads/2015/12/Nature-Lake-Bled.-Desktop-background-image-1680x1050.jpg", postBody: """
                             I noticed my feed on Lemmy was pretty dry today, even for Lemmy. Took me a while to realize lemmy.ml has been going up and down all morning, and isn’t federating new posts.

                             But, since this is all still federated, I can still create and read posts on other instances while I wait. Even this one! Any other service would just be unavailable completely right now.

                             I do miss the larger communities on lemmy.ml - asklemmy, memes, and I really wanted to watch the reddit fallout on /c/reddit. Maybe I’ll look around for some good replacements for those. Open to suggestions!
        """)
    }
}

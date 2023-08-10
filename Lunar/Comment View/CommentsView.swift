//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Kingfisher
import SwiftUI

struct CommentsView: View {
    @StateObject var commentsFetcher: CommentsFetcher
    @State var postID: Int
    var postTitle: String
    var thumbnailURL: String?
    var postBody: String?

    var body: some View {
        ScrollViewReader { _ in
            VStack {
                List {
                    Text(postTitle).font(.title).bold()
                        .listRowSeparator(.hidden)

                    if let thumbnailURL {
                        InPostThumbnailView(thumbnailURL: thumbnailURL)
                            .listRowSeparator(.hidden)
                    }

                    if let postBody {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundStyle(.regularMaterial)
                            Text(postBody)
                                .padding(10)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.bottom, 20)
                    }

                    ForEach(commentsFetcher.comments, id: \.comment.id) { comment in
                        HStack(spacing: 5) {
                            CommentIndentGuideView(commentPath: comment.comment.path)
                            VStack(alignment: .leading) {
                                Text(String(comment.creator.name.uppercased()))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                                    .padding(.vertical, 2)
                                Text(String(comment.comment.content))
                            }
                            .padding(.leading, 10)
                        }
                        .padding(.vertical, 5)
                        .task {
                            commentsFetcher.loadMoreContentIfNeeded(currentItem: comment)
                        }
                        .accentColor(Color.primary)
                    }
                    if commentsFetcher.isLoading {
                        ProgressView()
                    }
                }
                .refreshable {
                    await commentsFetcher.refreshContent()
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "chart.line.uptrend.xyaxis") }
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let commentsFetcher = CommentsFetcher(
            postID: 1_442_451,
            sortParameter: "Top",
            typeParameter: "All"
        )

        CommentsView(
            commentsFetcher: commentsFetcher,
            postID: 1_442_451,
            postTitle: MockData.commentsViewPostTitle1,
            thumbnailURL: MockData.commentsViewThumbnailURL1,
            postBody: MockData.commentsViewPostBody1
        )
    }
}

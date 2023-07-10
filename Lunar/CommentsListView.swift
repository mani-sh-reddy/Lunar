//
//  CommentsListView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

struct CommentsListView: View {
    @StateObject private var fetcher = Fetcher<CommentsListModel>()
    @State var commentsListModel = CommentsListModel(comments: [])
    @State var postId: Int
    @State var commentMaxDepth: Int = 50
    @State var postTitle: String


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(String(postTitle)).font(.title2).bold().padding(.vertical, 20)

                ForEach(fetcher.result?.comments ?? [], id: \.comment.id) { comment in
                    HStack(alignment: .center) {
                        ForEach(0 ... countPathDepth(in: comment.comment.path) - 2, id: \.self) { _ in
                            Rectangle()
                                .opacity(0.1)
                                .frame(width: 3)
                                .padding(.top, 10)
                                .padding(.bottom, 25)
                                .padding(.trailing, 5)
                        }
                        VStack(alignment: .leading) {
//                            Text(comment.comment.path).font(.footnote).padding(.bottom, 1)

                            Text((comment.creator.actorID).dropFirst(8)).textCase(.uppercase).font(.footnote).opacity(0.7)
                            Text(comment.comment.content).padding(.vertical, 1)
                            HStack(spacing: 2) {
                                CommentMetadataView(image: "arrow.up", value: comment.counts.upvotes)
                                CommentMetadataView(image: "arrow.down", value: comment.counts.downvotes)
                                CommentMetadataView(image: "flame", value: comment.counts.hotRank)
                                CommentMetadataView(image: "flowchart", value: comment.counts.childCount)
                            }.font(.footnote)
                                .padding(.vertical, 2)

                            Divider().padding(.vertical, 5)
                        }
                    }
                }

//                Text(String(commentMaxDepth)).font(.largeTitle).fontWeight(.bold)
//                Button("increase depth") {
//                    commentMaxDepth += 1
//                    loadComments()
//                }.font(.largeTitle)
//                    .background(.gray)
//                    .foregroundStyle(.white)
//                    .buttonBorderShape(.capsule)
//                Button("decrease depth") {
//                    commentMaxDepth -= 1
//                    loadComments()
//                }.font(.largeTitle)
//                    .background(.gray)
//                    .foregroundStyle(.white)
//                    .buttonBorderShape(.capsule)

            }.onAppear { loadComments() }
                .padding(.horizontal)
        }
    }

    func loadComments() {
        let urlString = "https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=50&post_id=\(postId)&max_depth=\(commentMaxDepth)"
        fetcher.fetchResponse(urlString: urlString)
    }

//    func convertActorIdToUsername(_ url: String) -> String? {
//        // Remove the "https://" prefix if present
//        var cleanedURL = url
//        if cleanedURL.hasPrefix("https://") {
//            cleanedURL = String(cleanedURL.dropFirst(8))
//        }
//
//        // Extract the username and domain
//        let components = cleanedURL.components(separatedBy: "/")
//
//        // Check if the URL has the expected format
//        guard components.count >= 4, let username = components[3].removingPercentEncoding else {
//            return nil
//        }
//
//        // Combine the username and domain in the desired format
//        let formattedString = "\(username)@\(components[2])"
//        return formattedString
//    }

    func countPathDepth(in string: String) -> Int {
        let elements = string.split(separator: Character("."))
        return elements.count
    }
}

struct CommentsListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsListView(postId: 1207586, postTitle: "This is a sample post title to test out the comments list view preview")
    }
}

struct CommentMetadataView: View {
    var image: String
    var value: Int

    var body: some View {
        Group {
            Text("  ")
            Image(systemName: image)
            Text(String(value))
        }.opacity(0.7)
    }
}

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
    @State var commentMaxDepth: Int = 1

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(String(commentMaxDepth)).font(.largeTitle)
                Button("increase depth") {
                    commentMaxDepth += 1
                    loadComments()
                }.font(.largeTitle)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .buttonBorderShape(.capsule)
                Button("decrease depth") {
                    commentMaxDepth -= 1
                    loadComments()
                }.font(.largeTitle)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .buttonBorderShape(.capsule)
                ForEach(fetcher.result?.comments ?? [], id: \.comment.id) { comment in

                    Text(comment.comment.path)
                    Text(comment.comment.content)
                    Text(comment.creator.name).bold()
                }
            }
            .onAppear {
                loadComments()
            }
        }.padding()
    }
    
    func loadComments(){
        let urlString = "https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=50&post_id=\(postId)&max_depth=\(commentMaxDepth)"
        fetcher.fetchResponse(urlString: urlString)
    }
}

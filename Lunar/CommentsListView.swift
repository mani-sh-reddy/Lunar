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
    @State var postId: Int
    @State var commentsListModel = CommentsListModel(comments: [])

    var body: some View {
        ScrollView {
            ForEach(fetcher.result?.comments ?? [], id: \.comment.id) { comment in
                VStack(alignment: .leading) {
                    Text(comment.comment.content)
                    Text("")
                }
            }
            .onAppear {
                let urlString = "https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=10&post_id=\(postId)"
                fetcher.fetchResponse(urlString: urlString)
            }
        }.padding()
    }
}

//
//  CommentsListView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Foundation
import SwiftUI
import Alamofire

struct CommentsListView: View {
    @State var commentDecoded: [CommentElement] = []
    @State var postId: Int
    
    var body: some View {
        ScrollView{
            ForEach(commentDecoded, id: \.comment.id) { comment in
                VStack (alignment: .leading){
                    Text(comment.comment.content)
                    Text("")
                }
            }
            Text("").hidden().disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .onAppear{
                    AF.request("https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=50&post_id=\(postId)")
                        .validate(statusCode: 200..<300)
                        .responseString(completionHandler: {str in
                            //                    print("str", str)
                        })
                        .responseDecodable(of: CommentsListModel.self) { response in
                            switch response.result {
                            case .success(let comments):
                                print(commentDecoded)
                                commentDecoded = comments.comments
                            case .failure(let error):
                                print(error)
                            }
                        }
                }
        }.padding()
    }
}

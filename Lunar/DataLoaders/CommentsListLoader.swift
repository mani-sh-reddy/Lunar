////
////  LoadTrendingCommunities.swift
////  Lunar
////
////  Created by Mani on 06/07/2023.
////
//
// import Foundation
//
//
// class CommentsListLoader: ObservableObject {
//    @Published var commentsList: [CommentElement] = []
//
//    func fetchComments(forPostId postId: Int) {
//        let postIdString = String(postId)
//        let url = URL(string: "https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=50&post_id=\(postIdString)")!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(CommentsListModel.self, from: data) {
//                    DispatchQueue.main.async {
//                        self.commentsList = decodedResponse.comments
//                    }
//                    return
//                }
//            }
//            if let error = error {
//                print("Fetch failed: \(error.localizedDescription)")
//            } else {
//                print("Fetch failed with unknown error.")
//            }
//        }.resume()
//    }
// }

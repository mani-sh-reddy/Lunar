//
//  CommentsListView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

//class Fetcher: ObservableObject {
//    @Published var commentDecoded: [CommentElement] = []
//
//    func fetchComments(urlString: String, commentsListModel: CommentsListModel) {
//        let cacher = ResponseCacher(behavior: .cache)
//        AF.request(urlString) {
//            urlRequest in
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//        }
//        .cacheResponse(using: cacher)
//        .validate(statusCode: 200 ..< 300)
//        .responseDecodable(of: CommentsListModel.self) { response in
//            switch response.result {
//            case .success(let comments):
//                self.commentDecoded = comments.comments
//            case .failure(let error):
//                print("ERROR: \(error): \(error.errorDescription ?? "")")
//            }
//        }
//    }
//}

class Fetcher: ObservableObject {
    @Published var commentDecoded: [CommentElement] = []

    func fetchComments<T: Decodable>(urlString: String, commentsListModel: CommentsListModel, responseType: T.Type) {
        let cacher = ResponseCacher(behavior: .cache)
        AF.request(urlString) { urlRequest in
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let comments):
                if let comments = comments as? CommentsListModel {
                    self.commentDecoded = comments.comments
                } else {
                    print("Unexpected response format")
                }
            case .failure(let error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

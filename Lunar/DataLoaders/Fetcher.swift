//
//  Fetcher.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

class Fetcher<ResultType: Decodable>: ObservableObject {
    @Published var result: ResultType?

    func fetchResponse(urlString: String) {
        let cacher = ResponseCacher(behavior: .cache)

        AF.request(urlString) { urlRequest in
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: ResultType.self) { response in
            switch response.result {
            case let .success(result):
                self.result = result

//                if let postsModel = result as? PostsModel {
//                    let cachableImageURLs = postsModel.thumbnailURLs.compactMap { URL(string: $0) }
//                        + postsModel.avatarURLs.compactMap { URL(string: $0) }
//                    let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in
////                        print("These resources are prefetched: \(completedResources)")
//                    }
//                    prefetcher.start()
//                } else if let communityModel = result as? CommunityModel {
//                    let iconURLs = communityModel.iconURLs.compactMap { URL(string: $0) }
//                    let prefetcher = ImagePrefetcher(urls: iconURLs) { _, _, _ in
////                        print("These resources are prefetched: \(completedResources)")
////                        print("These resources are skipped: \(skippedResources)")
//                    }
//                    prefetcher.start()
//                }

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

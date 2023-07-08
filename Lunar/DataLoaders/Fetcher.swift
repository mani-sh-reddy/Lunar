//
//  Fetcher.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

class Fetcher<ResultType: Decodable>: ObservableObject {
    @Published var result: ResultType?

    func fetchResponse(urlString: String) {
//        print("HIT fetchResponse for URL: \(urlString)")
        let cacher = ResponseCacher(behavior: .cache)
        AF.request(urlString) { urlRequest in
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: ResultType.self) { response in
            switch response.result {
            case .success(let result):
                self.result = result
            case .failure(let error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

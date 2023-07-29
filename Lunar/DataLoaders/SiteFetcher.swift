//
//  SiteFetcher.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

@MainActor class SiteFetcher: ObservableObject {
    @Published var myUser = [MyUser]()
    @Published var isLoading = false

    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser

    private var endpoint: URLComponents {
        URLBuilder(
            endpointPath: "/api/v3/site",
            authUser: selectedUser
        ).buildURL()
    }

    init() {
        loadContent()
    }

    private func loadContent() {
        print("selectedUser VALUE USED BY SiteFetcher loadContent: \(selectedUser)")
        guard !isLoading else { return }
        guard selectedUser != "" else { return }

        isLoading = true

        let cacher = ResponseCacher(behavior: .cache)

        AF.request(endpoint) { urlRequest in
            print("SiteFetcher LOAD \(urlRequest.url as Any)")
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: SiteModel.self) { response in
            switch response.result {
            case let .success(result):
                self.myUser = [result.myUser]
                self.isLoading = false

            case let .failure(error):
//                print("SiteFetcher ERROR ...")
                print("SiteFetcher ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

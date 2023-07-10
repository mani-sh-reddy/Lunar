//
//  PostsListFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import SwiftUI
import Kingfisher

class CommunitiesListFetcher: ObservableObject {
    @Published var communities: [CommunitiesElement] = []
    @State var iconURLs: [String] = []
    @Published var isLoaded: Bool = false

    func fetch(endpoint: String) {
        guard let url = URL(string: endpoint) else {
            return
        }
        AF.request(url)
            .responseDecodable(of: CommunityModel.self) { [weak self] response in
                switch response.result {
                case let .success(result):
                    
                    let imageURLStrings = result.iconURLs

                    let imageURLs = imageURLStrings.compactMap { URL(string: $0) }

                    let prefetcher = ImagePrefetcher(urls: imageURLs) {
                        skippedResources, failedResources, completedResources in
                        print("---------------------")
                        print("COMPLETED: \(completedResources.count)")
                        print("FAILED: \(failedResources.count)")
                        print("SKIPPED: \(skippedResources.count)")
                    }
                    prefetcher.start()
                    self?.communities = result.communities
                    self?.isLoaded = true
                    

                case let .failure(error):
                    print("ERROR: \(error): \(error.errorDescription ?? "")")
                }
            }
    }

//    func downloadImages(imageUrlsList: [String]) {
//        let urls = imageUrlsList.compactMap { URL(string: $0) }
//
//        let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory)
//        for imageURL in urls {
//            AF.download(imageURL, to: destination)
//                .downloadProgress { progress in
//                    print("Download Progress: \(progress.isFinished)")
//                }
//                .responseURL { _ in
//                }
//        }
//    }
}

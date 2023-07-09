//
//  PostsListFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import Nuke
import NukeUI
import SwiftUI

class PostsListFetcher: ObservableObject {
    @Published var posts: [PostElement] = []
    @Published var imageURLs: [String] = []
    @Published var isLoaded: Bool = false

    func fetch(endpoint: String) {
        guard let url = URL(string: endpoint) else {
            return
        }
        AF.request(url)
//        WILL BE USEFUL FOR IMAGES
//            .downloadProgress { progress in
//                // Update your progress indicator here
//                let loadingProgress = progress.fractionCompleted * 100
//                print("Download progress: \(loadingProgress)%")
//                DispatchQueue.main.async {
//                    if loadingProgress >= 100 {
//
//                    }
//                }
//            }
            .responseDecodable(of: PostsModel.self) { [weak self] response in
//            debugPrint("Response: \(response)")
                switch response.result {
                case let .success(result):

                    self?.downloadImages(imageUrlsList: result.thumbnailURLs + result.avatarURLs)

                    self?.isLoaded = true
                    self?.imageURLs = result.avatarURLs + result.thumbnailURLs
                    self?.posts = result.posts

                case let .failure(error):
                    print("ERROR: \(error): \(error.errorDescription ?? "")")
                }
            }
    }

    func downloadImages(imageUrlsList: [String]) {
        let urls = imageUrlsList.compactMap { URL(string: $0) }
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
        
        _ = urls.map { url in
            let request = ImageRequest(
                url: url,
                processors: [.resize(width: 100)],
                priority: .high
            )
            
            
        }
    }

//        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//        for imageURL in imageUrlsList {
//            if !imageURL.isEmpty {
//                AF.download(imageURL, to: destination)
//                    .downloadProgress { progress in
//                        print("Download Progress: \(progress.isFinished)")
//                    }
//                    .responseURL { response in
//                        print("DOWNLOD IMGES")
//                        print(String(response.response?.statusCode ?? 0))
//                    }
//            }
//        }

}

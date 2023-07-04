//
//  KbinPostsFetcher.swift
//  Lunar
//
//  Created by Mani on 11/12/2023.
//

import Alamofire
import Defaults
import Nuke
import SwiftUI

class KbinPostsFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.kbinSelectedInstance) var kbinSelectedInstance

  @Published var isLoading = false

  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  var sort: String?
  var time: String?
  var magazine: String?
  var instance: String?
  var filterKey: String
  var endpointPath: String

  @State private var page: Int = 1

  private var parameters: KbinEndpointParameters {
    KbinEndpointParameters(
      endpointPath: endpointPath,
      page: page,
      sort: sort,
      time: time,
      magazine: magazine,
      instance: instance
    )
  }

  init(
    sort: String?,
    time: String?,
//    magazine: String?,
    instance: String? = nil,
    page: Int,
    filterKey: String
  ) {
    endpointPath = "/api/posts"

    self.page = page
    self.sort = sort
    self.time = time
    self.instance = instance
//    self.magazine = magazine
    self.filterKey = filterKey
  }

  func loadContent(isRefreshing _: Bool = false) {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .doNotCache)

    AF.request(
      KbinEndpointBuilder(parameters: parameters).build()
    )
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: KbinPostsModel.self) { response in

      PulseWriter().writeKbin(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

//        let imageRequestList = result.hydraMember.compactMap  {
//          ImageRequest(url: URL(string: $0.), processors: [.resize(width: 200)])
//        }
//        self.imagePrefetcher.startPrefetching(with: imageRequestList)

        RealmWriter().writeKbinPosts(
          kbinPostObjects: result.posts,
          sort: self.sort,
          time: self.time,
          filterKey: self.filterKey
        )

        RealmWriter().writePage(
          pageCursor: "",
          pageNumber: self.page + 1,
          sort: self.sort,
          type: self.time,
          filterKey: self.filterKey
        )

        self.isLoading = false

      case let .failure(error):
        print("KbinPostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        self.isLoading = false
      }
    }
  }
}

////
////  PostsFetcher.swift
////  Lunar
////
////  Created by Mani on 23/07/2023.
////
//
// import Alamofire
// import Defaults
// import Nuke
// import SwiftUI
//
// class KbinPostsFetcher: ObservableObject {
//  @Default(.activeAccount) var activeAccount
//  @Default(.selectedInstanceKbin) var selectedInstanceKbin
//
//  @Published var isLoading = false
//
//  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)
//
//  var sort: String?
//  var time: String?
//  var magazine: String?
//  var instance: String?
//  var filterKey: String
//  var endpointPath: String
//
//  @State private var page: Int = 1
//
//  private var parameters: EndpointParametersKbin {
//    EndpointParametersKbin(
//      page: page,
//      endpointPath: endpointPath,
//      magazine: magazine,
//      sort: sort,
//      time: time,
//      instance: instance
//    )
//  }
//
//  init(
//    sort: String?,
//    time: String?,
//    magazine: String?,
//    instance: String? = nil,
//    page: Int,
//    filterKey: String
//  ) {
//
//    endpointPath = "/api/posts"
//
//    self.page = page
//    self.sort = sort
//    self.time = time
//    self.instance = instance
//    self.magazine = magazine
//    self.filterKey = filterKey
//  }
//
//  func loadContent(isRefreshing _: Bool = false) {
//    guard !isLoading else { return }
//
//    isLoading = true
//
//    let cacher = ResponseCacher(behavior: .doNotCache)
//
//    AF.request(
//      EndpointBuilderKbin(parameters: parameters).build()
//    )
//    .cacheResponse(using: cacher)
//    .validate(statusCode: 200 ..< 300)
//    .responseDecodable(of: KbinPostModel.self) { response in
//
//      PulseWriter().writeKbin(response, self.parameters, .get)
//
//      switch response.result {
//      case let .success(result):
//
////        let imageRequestList = result.hydraMember.compactMap  {
////          ImageRequest(url: URL(string: $0.), processors: [.resize(width: 200)])
////        }
////        self.imagePrefetcher.startPrefetching(with: imageRequestList)
//
//        RealmWriter().writeKbinPost(
//          kbinPostModel: result,
//          sort: self.sort,
//          time: self.time,
//          filterKey: self.filterKey
//        )
//
//        self.isLoading = false
//
//      case let .failure(error):
//        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
//        self.isLoading = false
//      }
//    }
//  }
// }

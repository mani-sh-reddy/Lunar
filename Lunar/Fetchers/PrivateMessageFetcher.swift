//
//  PrivateMessageFetcher.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Alamofire
import Combine
import Defaults
import Nuke
import Pulse
import RealmSwift
import SwiftUI

class PrivateMessageFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  @Published var isLoading = false

  var instance: String
  var endpointPath: String = "/api/v3/private_message/list"

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: endpointPath,
      jwt: JWT().getJWTForActiveAccount(),
      instance: instance
    )
  }

  init(
    instance: String
  ) {
    self.instance = instance
  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(EndpointBuilder(parameters: parameters).build(), headers: GenerateHeaders().generate()) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PrivateMessageModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

        RealmWriter().writePrivateMessage(privateMessages: result.privateMessages)

        self.isLoading = false

      case let .failure(error):
        print("PrivateMessageFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        self.isLoading = false
      }
    }
  }
}

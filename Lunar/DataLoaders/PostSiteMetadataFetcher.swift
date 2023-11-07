//
//  PostSiteMetadataFetcher.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class PostSiteMetadataFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.loggedInAccounts) var loggedInAccounts

  private var endpoint: URLComponents

  var urlString: String

  var loggedInAccount = AccountModel()
  let pulse = Pulse.LoggerStore.shared

  init(urlString: String) {
    self.urlString = urlString
    endpoint = URLBuilder(endpointPath: "/api/v3/post/site_metadata", urlString: urlString).buildURL()
  }

  func fetchPostSiteMetadata(completion: @escaping (SiteMetadataObject?) -> Void) {
    AF.request(endpoint)
      .validate(statusCode: 200 ..< 300)
      .responseDecodable(of: PostSiteMetadataResponseModel.self) { response in

        if self.networkInspectorEnabled {
          self.pulse.storeRequest(
            try! URLRequest(url: self.endpoint, method: .get),
            response: response.response,
            error: response.error,
            data: response.data
          )
        }

        switch response.result {
        case let .success(result):
          completion(result.metadata)

        case let .failure(error):
          if let data = response.data,
             let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
          {
            print("PostSiteMetadataFetcher ERROR: \(fetchError.error)")
            completion(nil)
          } else {
            print("PostSiteMetadataFetcher JSON DECODE ERROR: \(error): \(String(describing: error.errorDescription))")
            completion(nil)
          }
        }
      }
  }
}

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
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  private var urlString: String

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: "/api/v3/post/site_metadata",
      urlString: urlString
    )
  }

  init(urlString: String) {
    self.urlString = urlString
  }

  func fetchPostSiteMetadata(completion: @escaping (SiteMetadataObject?) -> Void) {
    AF.request(
      EndpointBuilder(parameters: parameters).build(),
      headers: GenerateHeaders().generate()
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PostSiteMetadataResponseModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

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

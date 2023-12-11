//
//  EndpointBuilderKbin.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Defaults
import Foundation
import SwiftUI

struct KbinEndpointParameters {
  var endpointPath: String
  var page: Int?
  var perPage: Int?
  var sort: String?
  var time: String?
  var magazine: String?
  var instance: String?
}

class KbinEndpointBuilder {
  @Default(.kbinSelectedInstance) var kbinSelectedInstance

  private let parameters: KbinEndpointParameters

  init(parameters: KbinEndpointParameters) {
    self.parameters = parameters
  }

  func build(redact _: Bool? = false) -> URLComponents {
    var endpoint = URLComponents()
    var queryParams: [String: String?] = [:]

    if let page = parameters.page { queryParams["p"] = String(page) }
    if let perPage = parameters.perPage { queryParams["perPage"] = String(perPage) }
    if let magazine = parameters.magazine { queryParams["magazine"] = String(magazine) }
    if let sort = parameters.sort { queryParams["sort"] = String(sort) }
    if let time = parameters.time { queryParams["time"] = String(time) }

    endpoint.scheme = "https"

    if let instance = parameters.instance {
      endpoint.host = instance
    } else {
      endpoint.host = kbinSelectedInstance
    }

    endpoint.path = parameters.endpointPath
    endpoint.setQueryItems(with: queryParams)

    print(endpoint.string ?? "")

    return endpoint
  }
}

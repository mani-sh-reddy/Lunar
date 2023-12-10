//
//  EndpointBuilderKbin.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Defaults
import Foundation
import SwiftUI

struct EndpointParametersKbin {
  var page: Int?
  var endpointPath: String
  var magazine: String?
  var sort: String?
  var time: String?
  var instance: String?
}

class EndpointBuilderKbin {
  @Default(.selectedInstanceKbin) var selectedInstanceKbin

  private let parameters: EndpointParametersKbin

  init(parameters: EndpointParametersKbin) {
    self.parameters = parameters
  }

  func build(redact _: Bool? = false) -> URLComponents {
    var endpoint = URLComponents()
    var queryParams: [String: String?] = [:]

    if let page = parameters.page { queryParams["page"] = String(page) }
    if let magazine = parameters.magazine { queryParams["magazine"] = String(magazine) }
    if let sort = parameters.sort { queryParams["sort"] = String(sort) }
    if let time = parameters.time { queryParams["time"] = String(time) }

    endpoint.scheme = "https"

    if let instance = parameters.instance {
      endpoint.host = instance
    } else {
      endpoint.host = selectedInstanceKbin
    }

    endpoint.path = parameters.endpointPath
    endpoint.setQueryItems(with: queryParams)

    return endpoint
  }
}

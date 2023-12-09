//
//  PulseWriter.swift
//  Lunar
//
//  Created by Mani on 06/12/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class PulseWriter {
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.selectedInstance) var selectedInstance

  let pulse = Pulse.LoggerStore.shared

  func write(
    _ response: DataResponse<some Any, AFError>,
    _ parameters: EndpointParameters,
    _ method: HTTPMethod
  ) {
    guard networkInspectorEnabled else { return }

    if method == .get {
      pulse.storeRequest(
        try! URLRequest(
          url: EndpointBuilder(parameters: parameters).build(redact: true),
          method: method
        ),
        response: response.response,
        error: response.error,
        data: response.data
      )
    } else if method == .post {
      pulse.storeRequest(
        try! URLRequest(
          url: URL(string: "https://\(selectedInstance)\(parameters.endpointPath)")!,
          method: method
        ),
        response: response.response,
        error: response.error,
        data: response.data
      )
    }
  }

  func writeKbin(
    _ response: DataResponse<some Any, AFError>,
    _ parameters: EndpointParametersKbin,
    _ method: HTTPMethod
  ) {
    guard networkInspectorEnabled else { return }

    if method == .get {
      pulse.storeRequest(
        try! URLRequest(
          url: EndpointBuilderKbin(parameters: parameters).build(redact: true),
          method: method
        ),
        response: response.response,
        error: response.error,
        data: response.data
      )
    } else if method == .post {
      pulse.storeRequest(
        try! URLRequest(
          url: URL(string: "https://\(selectedInstance)\(parameters.endpointPath)")!,
          method: method
        ),
        response: response.response,
        error: response.error,
        data: response.data
      )
    }
  }
}

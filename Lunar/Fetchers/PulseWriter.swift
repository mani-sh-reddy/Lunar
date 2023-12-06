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

  let pulse = Pulse.LoggerStore.shared

  func write(
    _ response: DataResponse<some Any, AFError>,
    _ parameters: EndpointParameters,
    _ method: HTTPMethod
  ) {
    guard networkInspectorEnabled else { return }

    pulse.storeRequest(
      try! URLRequest(
        url: EndpointBuilder(parameters: parameters).build(redact: true),
        method: method
      ),
      response: response.response,
      error: response.error,
      data: response.data
    )
  }
}

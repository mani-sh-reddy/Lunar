//
//  GenerateHeaders.swift
//  Lunar
//
//  Created by Mani on 06/12/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class GenerateHeaders {
  func generate(jwt: String? = JWT().getJWTForActiveAccount()) -> HTTPHeaders? {
    var headers: HTTPHeaders = []
    if let jwt {
      headers.add(.authorization(bearerToken: jwt))
    }
    return headers
  }
}

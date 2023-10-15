//
//  URLComponentsExtension.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation

extension URLComponents {
  mutating func setQueryItems(with parameters: [String: String?]) {
    queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
  }
}

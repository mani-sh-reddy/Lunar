//
//  URLParser.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

enum URLParser {
    static func extractDomain(from url: String) -> String {
        guard let urlComponents = URLComponents(string: url),
              let host = urlComponents.host
        else {
            return ""
        }

        if let range = host.range(of: #"^(www\.)?([a-zA-Z0-9-]+\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?$"#,
                                  options: .regularExpression)
        {
            return String(host[range])
        }

        return ""
    }

    static func extractPath(from url: String) -> String {
        guard let urlComponents = URLComponents(string: url) else {
            return ""
        }

        let path = urlComponents.path

        return path
    }

    static func extractUsername(from url: String) -> String {
        let path = extractPath(from: url)
        if let range = path.range(of: "/u/", options: .regularExpression) {
            return String(path[range.upperBound...])
        }
        return ""
    }
}

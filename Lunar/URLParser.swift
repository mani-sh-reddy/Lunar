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
}

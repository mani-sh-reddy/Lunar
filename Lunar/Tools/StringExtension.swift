//
//  StringExtension.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

extension String {
    func isValidExternalImageURL() -> Bool {
        let validURLs = [
            "i.imgur.com",
            "media1.giphy.com",
            "media.giphy.com",
            "files.catbox.moe",
            "i.postimg.cc",
        ]
        for url in validURLs {
            if contains(url) {
                return true
            }
        }
        return false
    }
}
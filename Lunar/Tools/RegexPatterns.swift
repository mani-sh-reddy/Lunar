//
//  RegexPatterns.swift
//  Lunar
//
//  Created by Mani on 16/10/2023.
//

import Foundation

// Utility class for regular expressions
enum RegexPatterns {
  static let matchAnyURL: NSRegularExpression? = {
    do {
      return try NSRegularExpression(
        pattern: #"(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?"#,
        options: []
      )
    } catch {
      return nil
    }
  }()
}

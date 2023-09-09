//
//  SFSymbols.swift
//  Lunar
//
//  Created by Mani on 09/09/2023.
//

//import Foundation
//import SwiftUI
//
//class SFSymbols {
//  
//  /// Singleton instance.
//  static let shared = SFSymbols()
//  
//  /// Array of all available symbol name strings.
//  let allSymbols: [String]
//  
//  private init() {
//      self.allSymbols = Self.fetchSymbols(fileName: "circleSFSymbols")
//  }
//  
//  private static func fetchSymbols(fileName: String) -> [String] {
//    guard let path = Bundle.main.path(forResource: fileName, ofType: "txt"),
//          let content = try? String(contentsOfFile: path) else {
//      return []
//    }
//    return content
//      .split(separator: "\n")
//      .map { String($0) }
//  }
//  
//}

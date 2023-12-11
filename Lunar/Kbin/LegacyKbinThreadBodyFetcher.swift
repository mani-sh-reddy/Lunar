//
//  LegacyKbinThreadBodyFetcher.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Alamofire
import SwiftSoup
import SwiftUI

class LegacyKbinThreadBodyFetcher: ObservableObject {
  @Published var postBody: String = ""
  @Published var isLoading = false

  var postURL: String

  init(
    postURL: String
  ) {
    self.postURL = postURL
    loadMoreContent()
  }

  func loadMoreContent() {
    guard !isLoading else { return }

    isLoading = true
    AF.request(postURL).response { response in
      if let data = response.data,
         let htmlString = String(data: data, encoding: .utf8)
      {
        do {
          let doc = try SwiftSoup.parse(htmlString)
          if let entryBody = try doc.select("div.entry__body").first() {
            let paragraphs = try entryBody.select("div.content.formatted p")
            var extractedText = ""
            for paragraph in paragraphs {
              extractedText += try paragraph.text() + "\n"
            }
            self.postBody = extractedText
          } else {
            print("Post body not found.")
          }
        } catch {
          print("Error parsing HTML: \(error)")
        }
      } else {
        print("Failed to get HTML content")
      }
      self.isLoading = false
    }
  }
}

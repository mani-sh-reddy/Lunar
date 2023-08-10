//
//  KbinCommentsFetcher.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Alamofire
import SwiftSoup
import SwiftUI

class KbinCommentsFetcher: ObservableObject {
  typealias FetchCompletion = ([KbinComment]) -> Void

  @Published var comments = [KbinComment]()
  @Published var isLoading = false

  @State var postURL: String

  private var currentPage = 1

  init(postURL: String) {
    self.postURL = postURL
    loadMoreContent()
  }

  func refreshContent() async {
    do {
      try await Task.sleep(nanoseconds: 1_000_000_000)
    } catch {}

    guard !isLoading else { return }
    currentPage = 1

    comments.removeAll()

    loadMoreContent()
  }

  func loadMoreContentIfNeeded(currentItem item: KbinComment?) {
    guard let item else {
      loadMoreContent()
      return
    }
    let thresholdIndex = comments.index(comments.endIndex, offsetBy: -1)
    if comments.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      loadMoreContent()
    }
  }

  func loadMoreContent(completion: FetchCompletion? = nil) {
    guard !isLoading else { return }

    isLoading = true

    AF.request(URL(string: postURL) ?? "").response { response in
      defer {
        self.isLoading = false
        completion?(self.comments)
      }

      if let data = response.data, let htmlString = String(data: data, encoding: .utf8) {
        self.parseComments(htmlString: htmlString)
      } else {
        print("Failed to get HTML content")
      }
    }
  }

  func parseComments(htmlString: String) {
    do {
      let doc = try SwiftSoup.parse(htmlString)
      let commentBlocks = try doc.select("blockquote.section.comment.entry-comment")

      for block in commentBlocks {
        let commentId = try block.attr("id")

        let elements: Elements = try block.select(
          "blockquote.section.comment.entry-comment.subject")

        var commentIndentLevel = "1"
        for element in elements {
          let classes = try element.classNames()
          let commentLevelClass = classes[4]
          if commentLevelClass.contains("comment-level--"), commentLevelClass.count == 16 {
            commentIndentLevel = String(commentLevelClass.last ?? "1")
          }
        }

        // Extract the user's name
        let usernameElement = try block.select("a.user-inline").first()
        let username = try usernameElement?.text()

        // Extract the comment content
        let contentElement = try block.select("div.content p").first()
        let content = try contentElement?.text()

        // Extract the time ago
        let timeElement = try block.select("time.timeago").first()
        let timeAgo = try timeElement?.text()

        // Create a KbinComment object
        let comment = KbinComment(
          id: commentId,
          indentLevel: commentIndentLevel,
          author: username ?? "",
          date: timeAgo ?? "",
          content: content ?? "",
          replies: []
        )
        comments.append(comment)
      }
    } catch {
      print("Error parsing HTML: \(error)")
    }
  }
}

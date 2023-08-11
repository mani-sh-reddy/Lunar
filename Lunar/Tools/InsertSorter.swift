//
//  InsertSorter.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation

enum InsertSorter {
  static func sortComments(_ newComment: CommentElement, into comments: inout [CommentElement]) {
    var index = comments.endIndex
    for (currentIndex, existingComment) in comments.enumerated() {
      if newComment.comment.path < existingComment.comment.path
        || (newComment.comment.path == existingComment.comment.path
          && newComment.comment.id < existingComment.comment.id) {
        index = currentIndex
        break
      }
    }
    comments.insert(newComment, at: index)
  }
}

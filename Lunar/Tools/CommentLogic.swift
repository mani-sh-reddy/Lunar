//
//  CommentLogic.swift
//  Lunar
//
//  Created by Mani on 15/09/2023.
//

import Foundation

extension CommentObject {
  var parentID: Int? {
    let pathComponents = comment.path.components(separatedBy: ".")

    if comment.path != "0", pathComponents.count != 2 {
      if let lastID = pathComponents.dropLast().last {
        return Int(lastID)
      }
    }

    return nil
  }
}

class NestedComment: ObservableObject {
  let commentViewData: CommentObject
  var subComments: [NestedComment]
  var indentLevel: Int

  init(commentData: CommentObject, subComments: [NestedComment]) {
    commentViewData = commentData
    self.subComments = subComments

    /// Calculating indent level
    let elements = commentData.comment.path.split(separator: ".").map { String($0) }
    let elementCount = elements.isEmpty ? 1 : elements.count - 1
    let indentLevel = elementCount >= 1 ? elementCount : 1

    self.indentLevel = indentLevel
  }
}

extension NestedComment: Identifiable {
  var commentID: Int { commentViewData.comment.id }
}

extension [CommentObject] {
  /// Convert a flat array of `APICommentView` into a hierarchical representation for UI rendering with parent-child relationships.
  var nestedComment: [NestedComment] {
    var comments = self

    // Partition the comments into parent and child categories
    let childCommentsStartIndex = comments.partition(by: { $0.parentID != nil })
    let childComments = comments[childCommentsStartIndex...]

    // Create a mapping of parent IDs to their child IDs
    var childIDsByParentID = [Int: [Int]]()
    childComments.forEach { childComment in
      guard let parentID = childComment.parentID else { return }
      childIDsByParentID[parentID] = (childIDsByParentID[parentID] ?? []) + [childComment.comment.id]
    }

    // Create a dictionary for efficient comment lookups by ID
    let commentsByID = Dictionary(uniqueKeysWithValues: comments.lazy.map { ($0.comment.id, $0) })

    /// Recursively build the hierarchical comment structure
    func buildHierarchicalComment(_ comment: CommentObject) -> NestedComment {
      guard let childIDs = childIDsByParentID[comment.comment.id] else {
        return .init(commentData: comment, subComments: [])
      }

      var nestedComment = NestedComment(commentData: comment, subComments: [])
      nestedComment.subComments = childIDs.compactMap { id -> NestedComment? in
        guard let childComment = commentsByID[id] else { return nil }
        return buildHierarchicalComment(childComment)
      }

      return nestedComment
    }

    // Extract parent comments from the original array
    let parentComments = comments[..<childCommentsStartIndex]

    // Build the hierarchical comment structure starting from parent comments
    let hierarchicalComments = parentComments.map(buildHierarchicalComment)
    return hierarchicalComments
  }
}

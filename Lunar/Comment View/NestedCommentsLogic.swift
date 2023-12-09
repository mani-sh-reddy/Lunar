//
//  NestedCommentsLogic.swift
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
  var commentViewData: CommentObject
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
  var nestedComment: [NestedComment] {
    var commentsByID: [Int: CommentObject] = [:]
    var childIDsByParentID = [Int: [Int]]()

    for comment in self {
      let id = comment.comment.id
      commentsByID[id] = comment

      if let parentID = comment.parentID {
        childIDsByParentID[parentID, default: []].append(id)
      }
    }

    func buildHierarchicalComment(_ comment: CommentObject) -> NestedComment {
      let nestedComment = NestedComment(commentData: comment, subComments: [])
      nestedComment.subComments = childIDsByParentID[comment.comment.id]?.compactMap { id in
        guard let childComment = commentsByID[id] else { return nil }
        return buildHierarchicalComment(childComment)
      } ?? []

      return nestedComment
    }

    let parentComments = filter { $0.parentID == nil }
    return parentComments.map(buildHierarchicalComment)
  }
}

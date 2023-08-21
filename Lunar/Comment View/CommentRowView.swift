//
//  CommentRowView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SwiftUI

struct CommentRowView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings.commentMetadataPosition
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @Binding var collapseToIndex: Int
  @Binding var collapserPath: String
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false
  
  let comment: CommentElement
  let listIndex: Int
  
  var indentLevel: Int {
    let elements = comment.comment.path.split(separator: ".").map { String($0) }
    let elementCount = elements.isEmpty ? 1 : elements.count - 1
    if elementCount >= 1 {
      return elementCount
    } else {
      return 1
    }
    
  }
  let commentHierarchyColors: [Color] = [
    .red,
    .orange,
    .yellow,
    .green,
    .cyan,
    .blue,
    .indigo,
    .purple,
  ]
  
  
  var body: some View {
    HStack {
      if debugModeEnabled {
        Text(String(listIndex))
      }
      ForEach(1..<indentLevel, id: \.self) { _ in
        Rectangle().opacity(0).frame(width: 0.1).padding(.horizontal, 0)
      }
      let indentLevel = min(indentLevel, commentHierarchyColors.count - 1)
      let foregroundColor = commentHierarchyColors[indentLevel]
      if indentLevel > 1 {
        Capsule(style: .continuous)
          .foregroundStyle(foregroundColor)
          .frame(width: 1)
          .padding(0)
      }
      VStack(alignment: .leading, spacing: 3) {
        if commentMetadataPosition == "Bottom" {
          Text(LocalizedStringKey(comment.comment.content))
          CommentMetadataView(comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted)
            .environmentObject(commentsFetcher)
        } else if commentMetadataPosition == "Top" {
          CommentMetadataView(comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted)
            .environmentObject(commentsFetcher)
          Text(LocalizedStringKey(comment.comment.content))
        } else {
          Text(LocalizedStringKey(comment.comment.content))
        }
      }
    }
    .onTapGesture {
      withAnimation(.smooth) {
        self.collapseToIndex = listIndex
        self.collapserPath = comment.comment.path
      }
    }
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      if indentLevel != 1 {
        Button {
          print("SWIPED")
          withAnimation(.smooth) {
            self.collapseToIndex = listIndex
            self.collapserPath = comment.comment.path
          }
        } label: {
          Image(systemName: "arrow.up.to.line.circle.fill")
        }
        .tint(.blue)
      }
    }
  }
}

//struct CollapseCommentsSwipeAction: View {
//  //  @Binding var isClicked: Bool
//  @Binding var collapseToIndex: Int
//  @Binding var collapserPath: String
//  var listIndex: Int
//  
//  var body: some View {
//    Button {
//      print("SWIPED")
//      withAnimation(.smooth) {
//        self.collapseToIndex = listIndex
//        self.collapserPath = comment.comment.path
//      }
//    } label: {
//      Image(systemName: "arrow.up.to.line.circle.fill")
//    }
//    .tint(.blue)
//  }
//}

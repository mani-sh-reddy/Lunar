//
//  RecursiveComment.swift
//  Lunar
//
//  Created by Mani on 16/09/2023.
//

import Defaults
import Foundation
import MarkdownUI
import SFSafeSymbols
import SwiftUI

struct RecursiveComment: View {
  @Default(.commentMetadataPosition) var commentMetadataPosition
  @Default(.activeAccount) var activeAccount
  @Default(.fontSize) var fontSize

  @State private var isExpanded = true
  @State var showCreateCommentPopover = false
  @State var blockUserDialogPresented = false
  @State var reportCommentSheetPresented = false
  @State var reportReasonHolder: String = ""

  @EnvironmentObject var commentsFetcher: CommentsFetcher

  let nestedComment: NestedComment
  let post: RealmPost

  let notificationHaptics = UINotificationFeedbackGenerator()

  let commentHierarchyColors: [Color] = [
    .clear, .red, .orange, .yellow, .green, .cyan, .blue, .indigo, .purple,
  ]

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    if !nestedComment.commentViewData.isCollapsed {
      HStack {
        commentNestedLevelIndicator
        maximisedCommentRow
        Spacer()
      }
      .fullScreenCover(isPresented: $showCreateCommentPopover) {
        commentPopoverAction
      }
      .contentShape(Rectangle())
      .onTapGesture { minimiseComment() }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        minimiseButton
        if !activeAccount.actorID.isEmpty {
          replyButton
        }
      }
      .contextMenu {
        shareButton
        Menu {
          reportCommentButton
          blockUserButton
        } label: {
          Label("More", systemSymbol: .ellipsisCircle)
        }
      }
      .confirmationDialog("", isPresented: $blockUserDialogPresented) {
        blockDialog
      } message: {
        Text("Block user \(URLParser.buildFullUsername(from: post.personActorID))")
      }
      .sheet(isPresented: $reportCommentSheetPresented) {
        reportCommentSheet
      }

      ForEach(nestedComment.subComments, id: \.id) { subComment in
        RecursiveComment(
          nestedComment: subComment,
          post: post
        )
        .padding(.leading, 10) // Add indentation
      }
    } else {
      minimisedCommentRow
        .contentShape(Rectangle())
        .onTapGesture { maximiseComment() }
    }
  }

  var reportCommentSheet: some View {
    List {
      Section {
        HStack {
          Text("Report Comment")
            .font(.title)
            .bold()
          Spacer()
          Button {
            reportCommentSheetPresented = false
          } label: {
            Image(systemSymbol: .xmarkCircleFill)
              .font(.largeTitle)
              .foregroundStyle(.secondary)
              .saturation(0)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      Section {
        VStack(alignment: .leading) {
          Text(URLParser.buildFullUsername(from: nestedComment.commentViewData.creator.actorID))
            .foregroundStyle(.secondary)
          Text(nestedComment.commentViewData.comment.content)
            .lineLimit(5)
            .truncationMode(.tail)
        }
      } header: {
        Text("Comment")
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      Section {
        TextEditor(text: $reportReasonHolder)
          .background(Color.clear)
          .font(.body)
          .frame(height: 150)
      } header: {
        Text("Reason")
      }

      Section {
        Button {
          let reportReason = reportReasonHolder
          reportCommentAction(reportReason: reportReason)
        } label: {
          Text("Report")
        }
        .tint(.red)
        .disabled(reportReasonHolder.isEmpty)
        Button {
          let reportReason = reportReasonHolder
          reportCommentAction(reportReason: reportReason)
          blockUserAction()
        } label: {
          Text("Report and Block User")
        }
        .tint(.red)
        .disabled(reportReasonHolder.isEmpty)
      }
    }
  }

  var shareButton: some View {
    Button {
      let items: [Any] = [nestedComment.commentViewData.comment.content]
      ShareSheet().share(items: items) {}
    } label: {
      Label("Share", systemSymbol: AllSymbols().shareContextIcon)
    }
  }

  var blockUserButton: some View {
    Button {
      blockUserDialogPresented = true
    } label: {
      Label("Block User", systemSymbol: AllSymbols().blockContextIcon)
    }
  }

  var reportCommentButton: some View {
    Button {
      reportCommentSheetPresented = true
    } label: {
      Label("Report Comment", systemSymbol: AllSymbols().reportContextIcon)
    }
  }

  @ViewBuilder
  var blockDialog: some View {
    Button("Block User") {
      blockUserAction()
    }
    Button("Report & Block") {
      blockUserDialogPresented = false
      reportCommentSheetPresented = true
    }
    Button("Dismiss", role: .cancel) {
      blockUserDialogPresented = false
    }
  }

  var minimisedCommentRow: some View {
    HStack {
      Text(nestedComment.commentViewData.comment.content)
        .italic()
        .lineLimit(1)
        .foregroundStyle(.gray)
        .font(.caption)
      Spacer()
      if countSubcomments(nestedComment.subComments) > 0 {
        Text(String(countSubcomments(nestedComment.subComments)))
          .bold()
          .font(.caption)
          .fixedSize()
          .foregroundStyle(.gray)
        Spacer().frame(width: 10)
      }
      Image(systemSymbol: .chevronForward)
        .foregroundStyle(.blue)
    }
  }

  var replyButton: some View {
    Button {
      showCreateCommentPopover = true
    } label: {
      Label("reply", systemSymbol: AllSymbols().replyContextIcon)
    }
    .tint(.indigo)
  }

  var minimiseButton: some View {
    Button {
      isExpanded.toggle()
      haptics.impactOccurred(intensity: 0.5)
      commentsFetcher.updateCommentCollapseState(
        nestedComment.commentViewData, isCollapsed: true
      )
      print("swipe action collapse clicked")
    } label: {
      Label("collapse", systemSymbol: AllSymbols().minimiseContextIcon)
    }
    .tint(.blue)
  }

  func minimiseComment() {
    isExpanded.toggle()
    haptics.impactOccurred(intensity: 0.5)
    commentsFetcher.updateCommentCollapseState(nestedComment.commentViewData, isCollapsed: true)
    print("tapped to collapse")
  }

  func maximiseComment() {
    isExpanded.toggle()
    haptics.impactOccurred(intensity: 0.5)
    commentsFetcher.updateCommentCollapseState(
      nestedComment.commentViewData, isCollapsed: false
    )
    print("tapped to expand")
  }

  @ViewBuilder
  var commentNestedLevelIndicator: some View {
    let indentLevel = min(nestedComment.indentLevel, commentHierarchyColors.count - 1)
    let color = commentHierarchyColors[indentLevel]
    if nestedComment.indentLevel > 1 {
      Rectangle()
        .foregroundColor(color)
        .frame(width: 2)
        .padding(.vertical, 5)
    }
  }

  @ViewBuilder
  var commentPopoverAction: some View {
    CreateCommentPopover(
      post: post,
      parentID: nestedComment.commentID,
      parentString: nestedComment.commentViewData.comment.content
    )
    .id(nestedComment.commentViewData.comment.id)
    .environmentObject(commentsFetcher)
  }

  var maximisedCommentRow: some View {
    VStack(alignment: .leading) {
      if commentMetadataPosition == "Top" {
        commentMetadata
      }

      Markdown { nestedComment.commentViewData.comment.content }
        .markdownTextStyle(\.text) { FontSize(fontSize) }
        .markdownTheme(.gitHub)

      if commentMetadataPosition == "Bottom" {
        commentMetadata
      }
    }
  }

  var commentMetadata: some View {
    CommentMetadataView(comment: nestedComment.commentViewData)
      .environmentObject(commentsFetcher)
  }

  func countSubcomments(_ nestedComments: [NestedComment]) -> Int {
    var count = 0

    for comment in nestedComments {
      count += 1 // Count the current comment
      count += countSubcomments(comment.subComments)
    }

    return count
  }

  func blockUserAction() {
    if let personID = nestedComment.commentViewData.creator.id {
      BlockUserSender(personID: personID, block: true).blockUser { _, userIsBlockedResponse, _ in
        if userIsBlockedResponse == true {
          if let index = commentsFetcher.comments.firstIndex(where: {
            $0.comment.id == nestedComment.commentViewData.comment.id
          }) {
            commentsFetcher.comments.remove(at: index)
          }
        }
      }
    }
  }

  func reportCommentAction(reportReason: String) {
    ReportSender(commentID: nestedComment.commentID, reportObjectType: .comment, reportReason: reportReason).sendReport { _, _, successful in
      print(successful)
      if successful == true {
        notificationHaptics.notificationOccurred(.success)
        reportCommentSheetPresented = false
      } else {
        notificationHaptics.notificationOccurred(.error)
      }
    }
  }
}

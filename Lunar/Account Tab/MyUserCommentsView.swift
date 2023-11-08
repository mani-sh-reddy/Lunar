//
//  MyUserCommentsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct MyUserCommentsView: View {
  @Default(.forcedPostSort) var forcedPostSort
  @Default(.selectedInstance) var selectedInstance
  @Default(.legacyPostsViewStyle) var legacyPostsViewStyle
  @Default(.commentMetadataPosition) var commentMetadataPosition

  var personFetcher: PersonFetcher
  var heading: String

  var listStyle: String {
    if legacyPostsViewStyle == "compactPlain" {
      "plain"
    } else {
      legacyPostsViewStyle
    }
  }

  var body: some View {
    List {
      ForEach(personFetcher.comments, id: \.comment.id) { comment in
        VStack(alignment: .leading) {
          if commentMetadataPosition == "Top" {
            MyUserCommentMetadataView(comment: comment)
          }
          Text(try! AttributedString(styledMarkdown: comment.comment.content))
          if commentMetadataPosition == "Bottom" {
            MyUserCommentMetadataView(comment: comment)
          }
        }
      }
      if personFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      personFetcher.loadContent(isRefreshing: true)
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .onChange(of: forcedPostSort) { _ in
      withAnimation {
        personFetcher.sortParameter = forcedPostSort.rawValue
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        SortTypePickerView(sortType: $forcedPostSort)
      }
    }
    .navigationTitle(heading)
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.grouped)
  }
}

struct MyUserCommentMetadataView: View {
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false

  let notificationHaptics = UINotificationFeedbackGenerator()
  var comment: CommentObject

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack(spacing: 0) {
          Text(comment.community.name)
            .bold()
          Text("@\(URLParser.extractDomain(from: comment.community.actorID))")
        }
        Text("\(TimestampParser().parse(originalTimestamp: comment.comment.published) ?? "") ago")
      }
      .padding(.top, 2)
      .font(.caption)
      .foregroundStyle(.secondary)
      Spacer()
      upvoteButton
      downvoteButton
    }
  }

  var upvoteButton: some View {
    ReactionButton(
      text: String(
        (commentUpvoted ? (comment.counts.upvotes ?? 0) + 1 : comment.counts.upvotes) ?? 0
      ),
      icon: SFSafeSymbols.SFSymbol.arrowUpCircleFill,
      color: Color.green,
      active: $commentUpvoted,
      opposite: $commentDownvoted
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        notificationHaptics.notificationOccurred(.error)
      }
    )
  }

  var downvoteButton: some View {
    ReactionButton(
      text: String((commentDownvoted ? (comment.counts.downvotes ?? 0) + 1 : comment.counts.downvotes) ?? 0),
      icon: SFSafeSymbols.SFSymbol.arrowDownCircleFill,
      color: Color.red,
      active: $commentDownvoted,
      opposite: $commentUpvoted
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        notificationHaptics.notificationOccurred(.error)
      }
    )
  }
}

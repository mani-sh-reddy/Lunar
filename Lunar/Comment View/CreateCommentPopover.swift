//
//  CreateCommentPopover.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct CreateCommentPopover: View {
  @Default(.activeAccount) var activeAccount

  @EnvironmentObject var commentsFetcher: CommentsFetcher

  @State private var userInputComment: String = ""
  @State private var userInputCommentEntry: String = ""
  @Binding var showingCreateCommentPopover: Bool

  var post: RealmPost
  var parentID: Int?
  var parentString: String?

  var submittable: Bool {
    !userInputCommentEntry.isEmpty
  }

  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    List {
      createCommentHeading
      if activeAccount.userID.isEmpty {
        notLoggedInWarning
      } else {
        replyingToSection
        replyingAsSection
        bodyField
        submitButtonSection
      }
    }
    .listStyle(.insetGrouped)
  }

  var notLoggedInWarning: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemSymbol: .personCropCircleBadgeExclamationmarkFill)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .padding(30)
          .symbolRenderingMode(.palette)
          .foregroundStyle(.yellow, .secondary)
        Text("Login to Comment")
          .bold()
          .font(.title2)
          .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var replyingToSection: some View {
    Section {
      Text(parentString ?? "")
    } header: {
      Text("Replying to:")
        .textCase(.none)
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var replyingAsSection: some View {
    Section {
      VStack(alignment: .leading) {
        HStack(spacing: 1) {
          Text(activeAccount.name)
            .bold()
          Text("@\(URLParser.extractDomain(from: activeAccount.actorID))")
            .foregroundStyle(.secondary)
        }
      }
    } header: {
      Text("Replying as:")
        .textCase(.none)
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var createCommentHeading: some View {
    Section {
      HStack {
        Text("Comment")
          .font(.title)
          .bold()
        Spacer()
        Button {
          showingCreateCommentPopover = false
        } label: {
          Image(systemSymbol: .xmarkCircleFill)
            .font(.largeTitle)
            .foregroundStyle(.secondary)
            .saturation(0)
        }
      }
    }
    .listRowBackground(Color.clear)
  }

  var bodyField: some View {
    Section {
      TextEditor(text: $userInputCommentEntry)
        .background(Color.clear)
        .font(.body)
        .frame(height: 150)
    } header: {
      Text("Body:")
        .textCase(.none)
    }
  }

  var submitButtonSection: some View {
    Section {
      Button {
        userInputComment = userInputCommentEntry
        if submittable {
          CommentSender(
            content: userInputComment,
            postID: post.postID,
            parentID: parentID
          ).fetchCommentResponse { response in
            if response == "success" {
              commentsFetcher.loadContent(isRefreshing: true)
              notificationHaptics.notificationOccurred(.success)
              showingCreateCommentPopover = false
            } else {
              notificationHaptics.notificationOccurred(.error)
              print("ERROR SENDING COMMENT")
            }
          }
        }
      } label: {
        HStack {
          Spacer()
          Text(submittable ? "Submit" : "Complete required fields to submit")
            .foregroundStyle(submittable ? .blue : .secondary)
          Spacer()
        }
      }
    }
  }
}

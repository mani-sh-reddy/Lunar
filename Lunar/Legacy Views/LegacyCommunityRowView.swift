//
//  LegacyCommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Nuke
import NukeUI
import SFSafeSymbols
import SwiftUI

struct LegacyCommunityRowView: View {
  @Default(.detailedCommunityLabels) var detailedCommunityLabels
  @Default(.legacyHiddenCommunitiesList) var legacyHiddenCommunitiesList

  var community: CommunityObject
  var communitiesFetcher: LegacyCommunitiesFetcher

  @State var showHideCommunityConfirmation = false

  var body: some View {
    if detailedCommunityLabels {
      HStack {
        communityIcon
        VStack(alignment: .leading, spacing: 2) {
          HStack(alignment: .center, spacing: 4) {
            communityTitle
            communityPropertiesLabels
          }
          HStack(spacing: 10) {
            communityCountsMetadata
          }
          .lineLimit(1)
          .foregroundStyle(.secondary)
          .font(.caption)
        }
        .padding(.horizontal, 10)
        Spacer()
        communityDomain
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//        goButton
        hideButton
      }
      .contextMenu {
        hideButton
      }
      .confirmationDialog(
        "Hide \(community.community.name)?",
        isPresented: $showHideCommunityConfirmation,
        actions: {
          Button("Hide", role: .destructive) {
            hideCommunityAction()
          }
        }
      )
    } else {
      HStack {
        communityIcon
        HStack(alignment: .center, spacing: 4) {
          communityTitle
          communityPropertiesLabels
        }
        .padding(.horizontal, 10)
        Spacer()
        communityDomain
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//        goButton
        hideButton
      }
      .contextMenu {
        hideButton
      }
      .confirmationDialog(
        "Hide \(community.community.name)?",
        isPresented: $showHideCommunityConfirmation,
        actions: {
          Button("Hide", role: .destructive) {
            hideCommunityAction()
          }
        }
      )
    }
  }

  var communityIcon: some View {
    LazyImage(url: URL(string: community.community.icon ?? "")) { state in
      if let image = state.image {
        image
          .resizable()
          .frame(width: 30, height: 30)
          .clipShape(Circle())
      } else {
        Image(systemSymbol: .booksVerticalCircleFill)
          .resizable()
          .frame(width: 30, height: 30)
          .symbolRenderingMode(.hierarchical)
          .foregroundStyle(.teal)
      }
    }
    .pipeline(ImagePipeline.shared)
    .processors([.resize(width: 60)])
  }

  var communityTitle: some View {
    Text(community.community.name).lineLimit(1)
      .foregroundStyle(community.community.actorID == "https://lemmy.world/c/lunar" ? Color.purple : Color.primary)
  }

  var communityDomain: some View {
    Text(String("\(URLParser.extractDomain(from: community.community.actorID))"))
      .font(.caption)
      .foregroundStyle(.gray)
      .fixedSize()
  }

  @ViewBuilder
  var communityPropertiesLabels: some View {
    postingRestrictedToModsLabel
    subscribedLabel
    pendingLabel
    nsfwLabel
  }

  @ViewBuilder
  var postingRestrictedToModsLabel: some View {
    if community.community.postingRestrictedToMods {
      Image(systemSymbol: .exclamationmarkOctagonFill)
        .font(.caption)
        .foregroundStyle(.yellow)
    }
  }

  @ViewBuilder
  var subscribedLabel: some View {
    if community.subscribed == .subscribed {
      Image(systemSymbol: .plusCircleFill)
        .font(.caption)
        .foregroundStyle(.green)
    }
  }

  @ViewBuilder
  var pendingLabel: some View {
    if community.subscribed == .pending {
      Image(systemSymbol: .arrowTriangle2CirclepathCircle)
        .font(.caption)
        .foregroundStyle(.yellow)
    }
  }

  @ViewBuilder
  var nsfwLabel: some View {
    if community.community.nsfw {
      Image(systemSymbol: ._18SquareFill)
        .font(.caption)
        .foregroundStyle(.pink)
    }
  }

  @ViewBuilder
  var communityCountsMetadata: some View {
    communitySubscribersCount
    communityPostsCount
    communityCommentsCount
  }

  var communitySubscribersCount: some View {
    HStack(spacing: 1) {
      Image(systemSymbol: .person2)
      Text((community.counts.subscribers)?.convertToShortString() ?? "0")
    }
    .foregroundStyle(
      community.counts.subscribers ?? 0 >= 10000 ? Color.yellow : Color.secondary)
  }

  var communityPostsCount: some View {
    HStack(spacing: 1) {
      Image(systemSymbol: .rectangleOnRectangle)
      Text((community.counts.posts)?.convertToShortString() ?? "0")
    }
  }

  var communityCommentsCount: some View {
    HStack(spacing: 1) {
      Image(systemSymbol: .quoteBubble)
      Text((community.counts.comments)?.convertToShortString() ?? "0")
    }
  }

//  var goButton: some View {
//    Button {
//      showingPlaceholderAlert = true
//    } label: {
//      Label("go", systemSymbol: AllSymbols().goIntoContextIcon)
//    }
//    .tint(.blue)
//  }

  var hideButton: some View {
    Button {
      showHideCommunityConfirmation = true
    } label: {
      Label("Hide", systemSymbol: AllSymbols().hideContextIcon)
    }
    .tint(.orange)
  }

  func hideCommunityAction() {
    legacyHiddenCommunitiesList.append(community.community.actorID)
    communitiesFetcher.communities.removeAll {
      legacyHiddenCommunitiesList.contains($0.community.actorID)
    }
  }
}

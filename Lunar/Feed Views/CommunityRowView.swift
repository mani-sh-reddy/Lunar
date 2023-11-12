//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Defaults
import Nuke
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct CommunityRowView: View {
  @Default(.detailedCommunityLabels) var detailedCommunityLabels

  @ObservedRealmObject var community: RealmCommunity

  @State var showingPlaceholderAlert = false

  var body: some View {
    if detailedCommunityLabels {
      HStack {
        communityIconView

        VStack(alignment: .leading, spacing: 2) {
          HStack(alignment: .center, spacing: 4) {
            communityNameView
            communityLabelIcons
          }
          communityCounts
        }
        .padding(.horizontal, 10)
        Spacer()
        instanceLabel
      }
      .contextMenu {
        unsubscribeContextMenuButton
      }
    } else {
      HStack {
        communityIconView
        communityNameView
      }
      .padding(.horizontal, 10)
      .contextMenu {
        unsubscribeContextMenuButton
      }
    }
  }

  var instanceLabel: some View {
    Text(String("\(URLParser.extractDomain(from: community.actorID))"))
      .font(.caption)
      .foregroundStyle(.gray)
      .fixedSize()
  }

  var communityCounts: some View {
    HStack(spacing: 10) {
      HStack(spacing: 1) {
        Image(systemSymbol: .person2)
        Text((community.subscribers)?.convertToShortString() ?? "0")
      }.foregroundStyle(
        community.subscribers ?? 0 >= 10000 ? Color.yellow : Color.secondary)
      HStack(spacing: 1) {
        Image(systemSymbol: .rectangleOnRectangle)
        Text((community.posts)?.convertToShortString() ?? "0")
      }
      HStack(spacing: 1) {
        Image(systemSymbol: .quoteBubble)
        Text((community.comments)?.convertToShortString() ?? "0")
      }
    }
    .lineLimit(1)
    .foregroundStyle(.secondary)
    .font(.caption)
  }

  @ViewBuilder
  var communityLabelIcons: some View {
    if community.postingRestrictedToMods {
      Image(systemSymbol: .exclamationmarkOctagonFill)
        .font(.caption)
        .foregroundStyle(.yellow)
    }
    /// Removing since the page is just for subscribed communities for now
//    if community.subscribed == .subscribed {
//      Image(systemSymbol: .plusCircleFill)
//        .font(.caption)
//        .foregroundStyle(.green)
//    }
    if community.subscribed == .pending {
      Image(systemSymbol: .arrowTriangle2CirclepathCircle)
        .font(.caption)
        .foregroundStyle(.yellow)
    }
  }

  var communityNameView: some View {
    Text(community.title ?? community.name).lineLimit(1)
      .foregroundStyle(community.id == 201_716 ? Color.purple : Color.primary)
  }

  var communityIconView: some View {
    LazyImage(url: URL(string: community.icon ?? "")) { state in
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

  var unsubscribeContextMenuButton: some View {
    Menu("Unsubscribe") {
      Button(role: .destructive) {
//        TODO: - SEND UNSUB ACTION
      } label: {
        Label("Delete", systemSymbol: AllSymbols().unsubscribeContextIcon)
          .tint(.red)
      }
    }
  }
}

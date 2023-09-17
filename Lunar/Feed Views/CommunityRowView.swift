//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Nuke
import NukeUI
import SwiftUI
import SFSafeSymbols

struct CommunityRowView: View {
  @AppStorage("detailedCommunityLabels") var detailedCommunityLabels = Settings.detailedCommunityLabels
  var community: CommunityObject

  @State var showingPlaceholderAlert = false

  var body: some View {
    if detailedCommunityLabels {
      HStack {
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
        .processors([.resize(width: 60)])

        VStack(alignment: .leading, spacing: 2) {
          HStack(alignment: .center, spacing: 4) {
            Text(community.community.name).lineLimit(1)
              .foregroundStyle(community.community.id == 201_716 ? Color.purple : Color.primary)

            if community.community.postingRestrictedToMods {
              Image(systemSymbol: .exclamationmarkOctagonFill)
                .font(.caption)
                .foregroundStyle(.yellow)
            }
            if community.subscribed == .subscribed {
              Image(systemSymbol: .plusCircleFill)
                .font(.caption)
                .foregroundStyle(.green)
            }
            if community.subscribed == .pending {
              Image(systemSymbol: .arrowTriangle2CirclepathCircle)
                .font(.caption)
                .foregroundStyle(.yellow)
            }
            if community.community.nsfw {
              Image(systemSymbol: ._18SquareFill)
                .font(.caption)
                .foregroundStyle(.pink)
            }
          }
          HStack(spacing: 10) {
            HStack(spacing: 1) {
              Image(systemSymbol: .person2)
              Text((community.counts.subscribers)?.convertToShortString() ?? "0")
            }.foregroundStyle(
              community.counts.subscribers ?? 0 >= 10000 ? Color.yellow : Color.secondary)
            HStack(spacing: 1) {
              Image(systemSymbol: .signpostRight)
              Text((community.counts.posts)?.convertToShortString() ?? "0")
            }
            HStack(spacing: 1) {
              Image(systemSymbol: .quoteBubble)
              Text((community.counts.comments)?.convertToShortString() ?? "0")
            }
          }.lineLimit(1)
            .foregroundStyle(.secondary)
            .font(.caption)

        }.padding(.horizontal, 10)
        Spacer()
        Text(String("\(URLParser.extractDomain(from: community.community.actorID))"))
          .font(.caption)
          .foregroundStyle(.gray)
          .fixedSize()
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("go", systemSymbol: .chevronForwardCircleFill)
        }.tint(.blue)
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("Hide", systemSymbol: .eyeSlashCircleFill)
        }.tint(.orange)
      }

      .contextMenu {
        Menu("Menu") {
          Button {
            showingPlaceholderAlert = true
          } label: {
            Text("Coming Soon")
          }
        }

        Button {
          showingPlaceholderAlert = true
        } label: {
          Text("Coming Soon")
        }

        Divider()

        Button(role: .destructive) {
          showingPlaceholderAlert = true
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
      .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
        Button("OK", role: .cancel) {}
      }
    } else {
      HStack {
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
        .processors([.resize(width: 60)])
        Text(community.community.title)
          .padding(.horizontal, 10)
      }

      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("go", systemSymbol: .chevronForwardCircleFill)
        }.tint(.blue)
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("Hide", systemSymbol: .eyeSlashCircleFill)
        }.tint(.orange)
      }

      .contextMenu {
        Menu("Menu") {
          Button {
            showingPlaceholderAlert = true
          } label: {
            Text("Coming Soon")
          }
        }

        Button {
          showingPlaceholderAlert = true
        } label: {
          Text("Coming Soon")
        }

        Divider()

        Button(role: .destructive) {
          showingPlaceholderAlert = true
        } label: {
          Label("Delete", systemSymbol: .trash)
        }
      }
      .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
        Button("OK", role: .cancel) {}
      }
    }
  }
}

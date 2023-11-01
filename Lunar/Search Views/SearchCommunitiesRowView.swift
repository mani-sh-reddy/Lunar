//
//  SearchCommunitiesRowView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Nuke
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct SearchCommunitiesRowView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @State var showingPlaceholderAlert = false

  var searchCommunitiesResults: [CommunityObject]

  var body: some View {
    ForEach(searchCommunitiesResults, id: \.community.id) { community in
      NavigationLink {
        //        PostsView(
        //          sort: "Active",
        //          type: "All",
        //          user: 0,
        //          communityID: 0,
        //          personID: 0,
        //          heading: community.community.title
        //        )
        PostsView(
          filteredPosts: realmPosts.filter { post in
            post.sort == "Active" && post.type == "All"
              && post.communityID == community.community.id && post.filterKey == "communitySpecific"
          },
          sort: "Active",
          type: "All",
          user: 0,
          communityID: community.community.id,
          personID: 0,
          filterKey: "communitySpecific",
          heading: community.community.title,
          communityName: community.community.name,
          communityActorID: community.community.actorID,
          communityDescription: community.community.description,
          communityIcon: community.community.icon
        )
        //        PostsView(
        //          postsFetcher: PostsFetcher(
        //            communityID: community.community.id
        //          ), title: community.community.name,
        //          community: community
        //        )
      } label: {
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
          .pipeline(ImagePipeline.shared)
          .processors([.resize(width: 30)])

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
                Image(systemSymbol: ._18CircleFill)
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
                Image(systemSymbol: .rectangleOnRectangle)
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
      }

      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button {
          showingPlaceholderAlert = true
        } label: {
          Image(systemSymbol: .chevronForwardCircleFill)
        }.tint(.blue)
        Button {
          showingPlaceholderAlert = true
        } label: {
          Image(systemSymbol: .eyeSlashCircleFill)
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

// struct SearchCommunitiesRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    SearchCommunitiesRowView(searchCommunitiesResults: MockData.searchCommunitiesResults)
//      .previewLayout(.sizeThatFits)
//  }
// }

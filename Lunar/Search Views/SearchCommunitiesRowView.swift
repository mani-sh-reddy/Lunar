//
//  SearchCommunitiesRowView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct SearchCommunitiesRowView: View {
  @State var showingPlaceholderAlert = false
  var searchCommunitiesResults: [CommunityElement]
  let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))

  var body: some View {
    ForEach(searchCommunitiesResults, id: \.community.id) { community in
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            communityID: community.community.id
          ), title: community.community.name,
          community: community
        )
      } label: {
        HStack {
          KFImage(URL(string: community.community.icon ?? ""))
            .setProcessor(processor)
            .placeholder {
              Image(systemName: "books.vertical.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.teal)
            }
            .resizable()
            .frame(width: 30, height: 30)
            .clipShape(Circle())

          VStack(alignment: .leading, spacing: 2) {
            HStack (alignment: .center, spacing: 4) {
              Text(community.community.name).lineLimit(1)
                .foregroundStyle(community.community.id == 201716 ? Color.purple : Color.primary)
              
              if community.community.postingRestrictedToMods {
                Image(systemName: "exclamationmark.octagon.fill")
                  .font(.caption)
                  .foregroundStyle(.yellow)
              }
              if community.subscribed == .subscribed {
                Image(systemName: "plus.circle.fill")
                  .font(.caption)
                  .foregroundStyle(.green)
              }
              if community.subscribed == .pending {
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                  .font(.caption)
                  .foregroundStyle(.yellow)
              }
              if community.community.nsfw {
                Image(systemName: "18.square.fill")
                  .font(.caption)
                  .foregroundStyle(.pink)
              }
            }
            HStack (spacing: 10) {
              HStack (spacing: 1) {
                Image(systemName: "person.2")
                Text((community.counts.subscribers).convertToShortString())
              }.foregroundStyle(community.counts.subscribers >= 10000 ? Color.yellow : Color.secondary )
              HStack (spacing: 1) {
                Image(systemName: "signpost.right")
                Text((community.counts.posts).convertToShortString())
              }
              HStack (spacing: 1) {
                Image(systemName: "quote.bubble")
                Text((community.counts.comments).convertToShortString())
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
          Label("go", systemImage: "chevron.forward.circle.fill")
        }.tint(.blue)
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("Hide", systemImage: "eye.slash.circle.fill")
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
    }
  }
}

struct SearchCommunitiesRowView_Previews: PreviewProvider {
  static var previews: some View {
    SearchCommunitiesRowView(searchCommunitiesResults: MockData.searchCommunitiesResults)
      .previewLayout(.sizeThatFits)
  }
}

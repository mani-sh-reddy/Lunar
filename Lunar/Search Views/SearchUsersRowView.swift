//
//  SearchUsersRowView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct SearchUsersRowView: View {
  @State var showingPlaceholderAlert = false
  var searchUsersResults: [UserElement]
  let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))

  var body: some View {
    ForEach(searchUsersResults, id: \.person.id) { person in
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            communityID: 99_999_999_999_999  // TODO change once implement user posts/comments fetcher
          ), title: person.person.name,
          user: person
        )
      } label: {
        HStack(alignment: .center) {
          KFImage(URL(string: person.person.avatar ?? ""))
            .setProcessor(processor)
            .placeholder {
              Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
            }
            .resizable()
            .frame(width: 30, height: 30)
            .clipShape(Circle())

          VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center, spacing: 4) {
              Text(person.person.name).lineLimit(1)
                .foregroundStyle(person.person.id == 35253 ? Color.purple : Color.primary)

              if person.person.banned {
                Image(systemName: "exclamationmark.triangle.fill")
                  .font(.caption)
                  .foregroundStyle(.secondary)
              }
              if person.person.botAccount {
                Image(systemName: "desktopcomputer")
                  .font(.caption)
                  .foregroundStyle(.blue)
              }
              if person.person.admin {
                Image(systemName: "checkmark.shield.fill")
                  .font(.caption)
                  .foregroundStyle(.yellow)
              }
            }
            HStack(spacing: 10) {
              HStack(spacing: 1) {
                Image(systemName: "arrow.up")
                Text((person.counts.postScore + person.counts.commentScore).convertToShortString())
              }.foregroundStyle(
                (person.counts.postScore + person.counts.commentScore) >= 100000
                  ? Color.yellow : Color.secondary)

              HStack(spacing: 1) {
                Image(systemName: "list.bullet.below.rectangle")
                Text((person.counts.postCount + person.counts.commentCount).convertToShortString())
              }
            }.lineLimit(1)
              .foregroundStyle(.secondary)
              .font(.caption)
          }
          .padding(.horizontal, 10)
          Spacer()
          Text(String("\(URLParser.extractDomain(from: person.person.actorID))"))
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

struct SearchUsersRowView_Previews: PreviewProvider {
  static var previews: some View {
    SearchUsersRowView(searchUsersResults: MockData.searchUserRow)
      .previewLayout(.sizeThatFits)
  }
}

//
//  SearchUsersRowView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Nuke
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct SearchUsersRowView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts
  @ObservedResults(RealmPage.self) var realmPage

  @State var showingPlaceholderAlert = false
  var searchUsersResults: [PersonObject]

  var body: some View {
    ForEach(searchUsersResults, id: \.person.id) { person in
      NavigationLink {
        PostsView(
          realmPage: realmPage.sorted(byKeyPath: "timestamp", ascending: false).first(where: {
            $0.sort == "Active"
              && $0.type == "All"
              && $0.personID == person.person.id
              && $0.filterKey == "personSpecific"
          }) ?? RealmPage(),
          filteredPosts: realmPosts.filter { post in
            post.sort == "Active"
              && post.type == "All"
              && post.personID == person.person.id
              && post.filterKey == "personSpecific"
          },
          sort: "Active",
          type: "All",
          user: 0,
          communityID: 0,
          personID: person.person.id ?? 0,
          filterKey: "personSpecific",
          heading: person.person.name,
          personName: person.person.name,
          personActorID: person.person.actorID,
          personBio: person.person.bio,
          personAvatar: person.person.avatar
        )
      } label: {
        UserRowDetailView(person: person)
      }

      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("go", systemSymbol: AllSymbols().goIntoContextIcon)
        }.tint(.blue)
        Button {
          showingPlaceholderAlert = true
        } label: {
          Label("Hide", systemSymbol: AllSymbols().hideContextIcon)
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

struct UserRowDetailView: View {
  var person: PersonObject

  var body: some View {
    HStack(alignment: .center) {
      LazyImage(url: URL(string: person.person.avatar ?? "")) { state in
        if let image = state.image {
          image
            .resizable()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        } else {
          Image(systemSymbol: .personCircleFill)
            .resizable()
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blue)
        }
      }
      .pipeline(ImagePipeline.shared)
      .processors([.resize(width: 30)])

      VStack(alignment: .leading, spacing: 2) {
        HStack(alignment: .center, spacing: 4) {
          Text(person.person.name).lineLimit(1)
            .foregroundStyle(person.person.id == 35253 ? Color.purple : Color.primary)

          if person.person.banned {
            Image(systemSymbol: .exclamationmarkTriangleFill)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          if person.person.botAccount {
            Image(systemSymbol: .desktopcomputer)
              .font(.caption)
              .foregroundStyle(.blue)
          }
          if person.person.admin != nil {
            Image(systemSymbol: .checkmarkShieldFill)
              .font(.caption)
              .foregroundStyle(.yellow)
          }
        }
        HStack(spacing: 10) {
          HStack(spacing: 1) {
            Image(systemSymbol: .arrowUp)
            Text(
              ((person.counts.postScore ?? 0) + (person.counts.commentScore ?? 0))
                .convertToShortString())
          }.foregroundStyle(
            ((person.counts.postScore ?? 0) + (person.counts.commentScore ?? 0)) >= 100_000
              ? Color.yellow : Color.secondary)

          HStack(spacing: 1) {
            Image(systemSymbol: .listBulletBelowRectangle)
            Text(
              ((person.counts.postCount ?? 0) + (person.counts.commentCount ?? 0))
                .convertToShortString())
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
}

// struct SearchUsersRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    SearchUsersRowView(searchUsersResults: MockData.searchUserRow)
//      .previewLayout(.sizeThatFits)
//  }
// }

//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 19/10/2023.
//

import Defaults
import Foundation
import MarkdownUI
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct PostsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.postsViewStyle) var postsViewStyle
  @Default(.selectedInstance) var selectedInstance
  @Default(.activeAccount) var activeAccount
  @Default(.fontSize) var fontSize

  var filteredPosts: [RealmPost]

  var sort: String
  var type: String
  var user: Int
  var communityID: Int
  var personID: Int
  var filterKey: String

  var heading: String

  var communityName: String?
  var communityActorID: String?
  var communityDescription: String?
  var communityIcon: String?

  var personName: String?
  var personActorID: String?
  var personBio: String?
  var personAvatar: String?

  @State var runOnce: Bool = false
  @State var page: Int = 1
  @State var showingCreatePostPopover: Bool = false

  @State var showingProgressView: Bool = false

  let hapticsRigid = UIImpactFeedbackGenerator(style: .rigid)

  var body: some View {
    List {
      if let communityActorID, !communityActorID.isEmpty {
        communitySpecificHeader
      }
      if let personActorID, !personActorID.isEmpty {
        personSpecificHeader
      }
      ForEach(filteredPosts) { post in
        switch postsViewStyle {
        case .large:
          PostItem(post: post)
        case .compact:
          CompactPostItem(post: post, navigable: true)
        }
      }
      .listRowBackground(Color("postListBackground"))
      if !runOnce {
        Rectangle()
          .foregroundStyle(.gray.opacity(0.1))
          .onAppear { loadMorePostsOnAppearAction() }
      } else {
        HStack {
          Spacer()
          if showingProgressView {
            ProgressView()
              .frame(width: 20)
          } else {
            Image(systemSymbol: .handTapFill)
              .imageScale(.small)
              .frame(width: 20)
          }
          Text("Load More Posts")
          Spacer()
        }
        .listRowBackground(Color("postListBackground"))
        .foregroundColor(.secondary)
        .font(.subheadline)
        .padding(.vertical, 10)
        .listRowSeparator(.hidden)
        .onTapGesture { loadMorePostsButtonAction() }
      }
    }
    .background(Color("postListBackground"))
    .listStyle(.plain)
    .navigationTitle(heading)
    .navigationBarTitleDisplayMode(.inline)
    .refreshable {
      showingProgressView = true
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      resetRealmPosts()
    }
    .onChange(of: selectedInstance) { _ in
      /// Resetting realm post action within InstanceSelectorView
      page = 1
      runOnce = false
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        if communityActorID != nil, !activeAccount.actorID.isEmpty {
          createPostButton
        }
        if debugModeEnabled {
          infoToolbar
        }
      }
    }
    .popover(isPresented: $showingCreatePostPopover) {
      CreatePostPopoverView(
        communityID: communityID,
        communityName: communityName ?? "",
        communityActorID: communityActorID ?? ""
      )
    }
  }

  func resetRealmPosts() {
    let realm = try! Realm()
    try! realm.write {
      let posts = realm.objects(RealmPost.self).where { post in
        (
          post.sort == sort
            && post.type == type
            && post.filterKey == "sortAndTypeOnly"
        )
          || (
            post.sort == sort
              && post.type == type
              && post.communityID == communityID
              && post.filterKey == "communitySpecific"
          )
          || (
            post.sort == sort
              && post.type == type
              && post.filterKey == "personSpecific"
          )
      }
      realm.delete(posts)
    }
    page = 1
    runOnce = false
  }

  var communitySpecificHeader: some View {
    Section {
      DisclosureGroup {
        Markdown { communityDescription ?? "" }
          .markdownTextStyle(\.text) { FontSize(fontSize) }
          .markdownTheme(.gitHub)
          .markdownImageProvider(.lazyImageProvider)
      } label: {
        HStack {
          communityIconView
          VStack(alignment: .leading) {
            Text(communityName ?? "")
              .bold()
            Text("@\(URLParser.extractDomain(from: communityActorID ?? ""))")
              .foregroundStyle(.secondary)
              .font(.caption)
          }
        }
      }
    }
    .listRowBackground(Color("postListBackground"))
    .listRowSeparator(.hidden)
  }

  var communityIconView: some View {
    LazyImage(url: URL(string: communityIcon ?? "")) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .clipShape(Circle())
          .frame(width: 60, height: 60)
      } else if state.error != nil {
        Image(systemSymbol: .booksVerticalCircleFill)
          .resizable()
          .frame(width: 60, height: 60)
          .foregroundStyle(.secondary)
          .symbolRenderingMode(.hierarchical)
      } else {
        Color.clear.frame(width: 60, height: 60)
      }
    }
    .padding(5)
  }

  var personSpecificHeader: some View {
    Section {
      DisclosureGroup {
        Markdown { personBio ?? "" }
          .markdownTextStyle(\.text) { FontSize(fontSize) }
          .markdownTheme(.gitHub)
          .markdownImageProvider(.lazyImageProvider)
      } label: {
        HStack {
          personAvatarView
          VStack(alignment: .leading) {
            Text(personName ?? "")
              .bold()
            Text("@\(URLParser.extractDomain(from: personActorID ?? ""))")
              .foregroundStyle(.secondary)
              .font(.caption)
          }
        }
      }
    }
    .listRowBackground(Color("postListBackground"))
    .listRowSeparator(.hidden)
  }

  var personAvatarView: some View {
    LazyImage(url: URL(string: personAvatar ?? "")) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .clipShape(Circle())
          .frame(width: 60, height: 60)
      } else if state.error != nil {
        Image(systemSymbol: .personCircleFill)
          .resizable()
          .frame(width: 60, height: 60)
          .foregroundStyle(.secondary)
          .symbolRenderingMode(.hierarchical)
      } else {
        Color.clear.frame(width: 60, height: 60)
      }
    }
    .padding(5)
  }

  var createPostButton: some View {
    Button {
      showingCreatePostPopover = true
    } label: {
      Image(systemSymbol: .rectangleFillBadgePlus)
    }
  }

  var infoToolbar: some View {
    HStack(alignment: .lastTextBaseline) {
      VStack {
        Image(systemSymbol: .signpostRight)
        Text(String(filteredPosts.count))
          .fixedSize()
      }
      .padding(.trailing, 3)
      VStack {
        Image(systemSymbol: .doc)
        Text(String(page))
          .fixedSize()
      }
    }
    .font(.caption)
  }

  func loadMorePostsOnAppearAction() {
    showingProgressView = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        personID: personID,
        page: page,
        filterKey: filterKey
      ).loadContent()
      /// Setting the page number for the batch.
      page += 1
      showingProgressView = false
    }
    runOnce = true
  }

  func loadMorePostsButtonAction() {
    showingProgressView = true
    hapticsRigid.impactOccurred(intensity: 0.5)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        personID: personID,
        page: page,
        filterKey: filterKey
      ).loadContent()
      showingProgressView = false
      page += 1
    }
  }
}

#Preview {
  PostItem(post: MockData().post).previewLayout(.sizeThatFits)
}

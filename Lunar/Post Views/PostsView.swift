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

  @ObservedRealmObject var realmPage: RealmPage

  @ObservedResults(RealmPage.self) var realmPages

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
  @State var showingCreatePostPopover: Bool = false

  @State var showingProgressView: Bool = false

  let hapticsRigid = UIImpactFeedbackGenerator(style: .rigid)

  // MARK: - body

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
          .onAppear {
            loadMorePostsOnAppearAction()
          }
      } else {
        HStack {
          Spacer()
          if showingProgressView {
            ProgressView()
              .foregroundStyle(.blue)
              .frame(width: 20)
          } else {
            Image(systemSymbol: .handTapFill)
              .foregroundStyle(.blue)
              .imageScale(.small)
              .frame(width: 20)
          }
          Text("Load Posts")
            .foregroundStyle(.blue)
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
    .navigationTitle(debugModeEnabled ? "" : heading)
    .navigationBarTitleDisplayMode(.inline)
    .refreshable {
      print("__REFRESHED_POSTS_VIEW__")
      showingProgressView = true
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      print("__REFRESHED_POSTS_VIEW_AFTER_WAIT__")
      resetRealmPages()
      resetRealmPosts()
      showingProgressView = false
    }
    .onChange(of: selectedInstance) { _ in
      /// Resetting realm post action within InstanceSelectorView
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
        showingCreatePostPopover: $showingCreatePostPopover,
        communityID: communityID,
        communityName: communityName ?? "",
        communityActorID: communityActorID ?? ""
      )
    }
  }

  // MARK: - resetRealmPosts

//  func resetRealmPosts() {
//    guard !filteredPosts.isEmpty else { return }
//    for post in filteredPosts {
//      print("__DELETE_POST_\(post.postID)__")
//      RealmThawFunctions().deletePost(post: post)
//    }
  ////    RealmThawFunctions().deleteMultiplePosts(posts: filteredPosts)
//    runOnce = false
//  }

  func resetRealmPosts() {
    let realm = try! Realm()
    try! realm.write {
      let posts = realm.objects(RealmPost.self).where { post in
        post.sort == sort
          && post.type == type
          && post.filterKey == filterKey
      }
      realm.delete(posts)
    }
  }

  func resetRealmPages() {
    guard !realmPages.filter({
      $0.sort == sort
      && $0.type == type
      && $0.filterKey == filterKey
    }).isEmpty else { return }
    for page in realmPages.filter({
      $0.sort == sort
        && $0.type == type
        && $0.filterKey == filterKey
    }) {
      RealmThawFunctions().resetRealmPage(page: page)
    }
  }

  // MARK: - communitySpecificHeader

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

  // MARK: - communityIconView

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

  // MARK: - personSpecificHeader

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

  // MARK: - personAvatarView

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

  // MARK: - createPostButton

  var createPostButton: some View {
    Button {
      showingCreatePostPopover = true
    } label: {
      Image(systemSymbol: .rectangleFillBadgePlus)
    }
  }

  // MARK: - infoToolbar

  var infoToolbar: some View {
    HStack(alignment: .lastTextBaseline) {
      VStack {
        Image(systemSymbol: .signpostRight)
        Text(String(filteredPosts.count))
          .fixedSize()
      }
      .padding(.trailing, 3)
      VStack {
        Image(systemSymbol: .arrowRightDocOnClipboard)
        Text(String(realmPage.pageNumber ?? 99999))
          .fixedSize()
      }
      Text(realmPage.pageCursor ?? "")
    }
    .font(.caption)
  }

  // MARK: - loadMorePostsOnAppearAction

  func loadMorePostsOnAppearAction() {
    showingProgressView = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        personID: personID,
          pageNumber: realmPage.pageNumber ?? 1,
        pageCursor: realmPage.pageCursor,
        filterKey: filterKey
      ).loadContent()
      /// Setting the page number for the batch.
      showingProgressView = false
    }
    runOnce = true
  }

  // MARK: - loadMorePostsButtonAction

  func loadMorePostsButtonAction() {
    showingProgressView = true
    hapticsRigid.impactOccurred(intensity: 0.5)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        personID: personID,
          pageNumber: realmPage.pageNumber ?? 1,
        pageCursor: realmPage.pageCursor,
        filterKey: filterKey
      ).loadContent()
      showingProgressView = false
      }
    }
  }
}

#Preview {
  PostItem(post: MockData().post).previewLayout(.sizeThatFits)
}

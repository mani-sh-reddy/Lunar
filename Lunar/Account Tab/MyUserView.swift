//
//  MyUserView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Defaults
import Nuke
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct MyUserView: View {
  @ObservedResults(RealmPost.self) var realmPosts
  @ObservedResults(RealmPage.self) var realmPage

  @Default(.activeAccount) var activeAccount

//  @GestureState var dragAmount = CGSize.zero
  @State var hasRunOnceMyPosts: Bool = false
  @State var hasRunOnceSavedPosts: Bool = false
  @State var hasRunOnceMyComments: Bool = false
  @State var hasRunOnceSavedComments: Bool = false

  var avatar: String { activeAccount.avatarURL }
  var actorID: String { activeAccount.actorID }
  var userID: Int { Int(activeAccount.userID) ?? 0 }
  var name: String { activeAccount.name }
  var postScore: String { String(activeAccount.postScore) }
  var commentScore: String { String(activeAccount.commentScore) }
//  var postCount: String { String(activeAccount.postCount) }
  var postCount: String {
    String(realmPosts.filter { post in
      post.filterKey == "MY_POSTS"
    }.count)
  }

  var commentCount: String { String(activeAccount.commentCount) }

  var userInstance: String {
    if !actorID.isEmpty {
      "@\(URLParser.extractDomain(from: actorID))"
    } else {
      "Login to view"
    }
  }

  var body: some View {
    NavigationView {
      List {
        userDetailsSection
        scoreSection
        Group {
          Section {
            myPosts
            myComments
          }
          Section {
            savedPosts
            savedComments
          }
        }
        .modifier(BlurredAndDisabledModifier(style: actorID.isEmpty ? .disabled : .none))
      }
      .listStyle(.insetGrouped)
      .onAppear {
        DispatchQueue.global(qos: .background).async {
          if let jwt = JWT().getJWT(actorID: activeAccount.actorID) {
            SiteInfoFetcher(jwt: jwt).fetchSiteInfo { _, _, _, _ in }
          }
        }
      }
    }
  }

  // MARK: - userDetailsSection

  var userDetailsSection: some View {
    Section {
      HStack {
        Spacer()
        LazyImage(url: URL(string: avatar)) { state in
          if let image = state.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
          } else {
            Image(systemSymbol: .personCircleFill)
              .resizable()
              .symbolRenderingMode(.hierarchical)
          }
        }
        .pipeline(ImagePipeline.shared)
        .processors([.resize(width: 300)])

        .frame(width: 250, height: 250)
        .transition(.opacity)
        .padding(.bottom, 10)

        Spacer()
      }

//      .offset(dragAmount)
//      .gesture(
//        DragGesture().updating($dragAmount) { value, state, _ in
//          state = value.translation
//        }
//      )

      HStack {
        Spacer()
        VStack {
          Text(name)
            .font(.largeTitle).bold()
            .padding(1)
          Text(userInstance)
            .font(.title2).bold()
            .foregroundStyle(.secondary)
        }
        Spacer()
      }
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  // MARK: - myPosts

  var myPosts: some View {
    NavigationLink {
      if userID != 0 {
        PostsView(
          realmPage: realmPage.sorted(byKeyPath: "timestamp", ascending: false).first(where: {
            $0.sort == "New"
              && $0.type == "All"
              && $0.filterKey == "MY_POSTS"
          }) ?? RealmPage(),
          filteredPosts: realmPosts.filter { post in
            post.filterKey == "MY_POSTS"
          },
          sort: "New",
          type: "All",
          user: 0,
          communityID: 0,
          personID: userID,
          filterKey: "MY_POSTS",
          heading: "My Posts"
        )
      }
    } label: {
      Label {
        HStack {
          Text("Posts")
          Spacer()
          Text(postCount).bold().foregroundStyle(.gray)
        }
      } icon: {
        Image(systemSymbol: .rectangleOnRectangleAngled)
          .foregroundStyle(.purple)
      }
    }
    .onAppear {
      if !hasRunOnceMyPosts {
        PersonFetcher(sortParameter: "New", typeParameter: "All", savedOnly: false, personID: userID).loadContent()
        hasRunOnceMyPosts = true
      }
    }
  }

  // MARK: - myComments

  var myComments: some View {
    NavigationLink {
      if userID != 0, !hasRunOnceMyComments {
        MyUserCommentsView(
          personFetcher: PersonFetcher(
            sortParameter: "New",
            typeParameter: "All",
            personID: userID
          ),
          heading: "My Comments"
        )
        let _ = hasRunOnceMyComments = true
      }
    } label: {
      Label {
        Text("Comments")
        Spacer()
        Text(commentCount).bold().foregroundStyle(.gray)
      } icon: {
        Image(systemSymbol: .textBubble)
          .foregroundStyle(.cyan)
      }
    }
  }

  // MARK: - savedPosts

  var savedPosts: some View {
    NavigationLink {
      if userID != 0 {
        PostsView(
          realmPage: realmPage.sorted(byKeyPath: "timestamp", ascending: false).first(where: {
            $0.sort == "New"
              && $0.type == "All"
              && $0.filterKey == "MY_POSTS_SAVED_ONLY"
          }) ?? RealmPage(),
          filteredPosts: realmPosts.filter { post in
            post.filterKey == "MY_POSTS_SAVED_ONLY"
          },
          sort: "New",
          type: "All",
          user: 0,
          communityID: 0,
          personID: userID,
          filterKey: "MY_POSTS_SAVED_ONLY",
          heading: "Saved Posts"
        )
      }
    } label: {
      Label {
        Text("Saved Posts")

      } icon: {
        Image(systemSymbol: .star)
          .foregroundStyle(.yellow)
      }
    }
    .onAppear {
      if !hasRunOnceSavedPosts {
        PersonFetcher(sortParameter: "New", typeParameter: "All", savedOnly: true, personID: userID).loadContent()
        hasRunOnceSavedPosts = true
      }
    }
  }

  // MARK: - savedComments

  var savedComments: some View {
    NavigationLink {
      if userID != 0, !hasRunOnceSavedComments {
        MyUserCommentsView(
          personFetcher: PersonFetcher(
            sortParameter: "New",
            typeParameter: "All",
            savedOnly: true,
            personID: userID
          ),
          heading: "Saved Comments"
        )
        let _ = hasRunOnceSavedComments = true
      }
    } label: {
      Label {
        Text("Saved Comments")

      } icon: {
        Image(systemSymbol: .starBubble)
          .foregroundStyle(.orange)
      }
    }
  }

  // MARK: - scoreSection

  var scoreSection: some View {
    Section {
      HStack {
        AccountScoreView(
          title: "Post Score",
          score: postScore,
          isOnLeft: true
        )
        Divider()
        AccountScoreView(
          title: "Comment Score",
          score: commentScore,
          isOnLeft: false
        )
      }
    }
    .modifier(BlurredAndDisabledModifier(style: actorID.isEmpty ? .disabled : .none))
  }
}

#Preview {
  MyUserView()
}

// MARK: - AccountScoreView

struct AccountScoreView: View {
  var title: String
  var score: String
  var isOnLeft: Bool

  var body: some View {
    HStack {
      Spacer()
      if !isOnLeft {
        Rectangle()
          .foregroundStyle(.clear)
          .frame(width: 5)
      }
      VStack(alignment: .center) {
        Text(title)
          .textCase(.uppercase)
          .font(.caption)
          .foregroundStyle(.secondary)
          .padding(.bottom, 1)
        Text(score)
          .font(.title)
      }
      if isOnLeft {
        Rectangle()
          .foregroundStyle(.clear)
          .frame(width: 5)
      }
      Spacer()
    }
  }
}

//
//  MyUserView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Defaults
import Nuke
import NukeUI
import SFSafeSymbols
import Shiny
import SwiftUI

struct MyUserView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.iridescenceEnabled) var iridescenceEnabled

  @GestureState var dragAmount = CGSize.zero

  var avatar: String { activeAccount.avatarURL }
  var actorID: String { activeAccount.actorID }
  var userID: Int { Int(activeAccount.userID) ?? 0 }
  var name: String { activeAccount.name }
  var postScore: String { String(activeAccount.postScore) }
  var commentScore: String { String(activeAccount.commentScore) }
  var postCount: String { String(activeAccount.postCount) }
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
        postsAndCommentsSection
        savedPostsAndCommentsSection
      }
      .listStyle(.insetGrouped)
      .onAppear {
        if let jwt = JWT().getJWTFromKeychain(actorID: activeAccount.actorID) {
          SiteInfoFetcher(jwt: jwt).fetchSiteInfo { _, _, _, _ in }
        }
      }
    }
  }

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

      .offset(dragAmount)
      .gesture(
        DragGesture().updating($dragAmount) { value, state, _ in
          state = value.translation
        }
      )

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

  var postsAndCommentsSection: some View {
    Section {
      NavigationLink {
        if userID != 0 {
          MyUserObserver(
            personFetcher: PersonFetcher(
              sortParameter: "New",
              typeParameter: "All",
              personID: userID
            ),
            userName: name,
            viewType: "Posts"
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

      NavigationLink {
        if userID != 0 {
          MyUserObserver(
            personFetcher: PersonFetcher(
              sortParameter: "New",
              typeParameter: "All",
              personID: userID
            ),
            userName: name,
            viewType: "Comments"
          )
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
    .modifier(BlurredAndDisabledModifier(style: actorID.isEmpty ? .disabled : .none))
  }

  var savedPostsAndCommentsSection: some View {
    Section {
      NavigationLink {
        if userID != 0 {
          MyUserObserver(
            personFetcher: PersonFetcher(
              sortParameter: "New",
              typeParameter: "All",
              savedOnly: true,
              personID: userID
            ),
            userName: name,
            viewType: "Saved Posts"
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
      NavigationLink {
        if userID != 0 {
          MyUserObserver(
            personFetcher: PersonFetcher(
              sortParameter: "New",
              typeParameter: "All",
              savedOnly: true,
              personID: userID
            ),
            userName: name,
            viewType: "Saved Comments"
          )
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
    .modifier(BlurredAndDisabledModifier(style: actorID.isEmpty ? .disabled : .none))
  }

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
    .modifier(
      ConditionalListRowBackgroundModifier(
        background: iridescenceEnabled ? .iridescent : .defaultBackground))
  }
}

#Preview {
  MyUserView()
}

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

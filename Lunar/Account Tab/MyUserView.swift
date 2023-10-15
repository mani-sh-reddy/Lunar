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
  @Default(.selectedActorID) var selectedActorID
  @Default(.loggedInAccounts) var loggedInAccounts
  @Default(.selectedUser) var selectedUser

  var myAccount: AccountModel {
    if !selectedUser.isEmpty {
//      print(selectedUser)
      return selectedUser[0]
    }
    return AccountModel(
      userID: "",
      name: "",
      email: "",
      avatarURL: "",
      actorID: ""
    )
  }

  var avatar: String { myAccount.avatarURL }
  var actorID: String { myAccount.actorID }
  var userID: Int { Int(myAccount.userID) ?? 0 }
  var name: String { myAccount.name }
  var postScore: String { String(myAccount.postScore) }
  var commentScore: String { String(myAccount.commentScore) }
  var postCount: String { String(myAccount.postCount) }
  var commentCount: String { String(myAccount.commentCount) }

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
        if let jwt = JWT().getJWTFromKeychain(actorID: selectedActorID) {
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
        .processors([.resize(width: 100)])

        .frame(width: 150, height: 150)
        .transition(.opacity)
        .padding(.bottom, 10)

        Spacer()
      }
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
        MyUserObserver(
          personFetcher: PersonFetcher(
            sortParameter: "New",
            typeParameter: "All",
            personID: userID
          ),
          userName: name,
          viewType: "Posts"
        )
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
        MyUserObserver(
          personFetcher: PersonFetcher(
            sortParameter: "New",
            typeParameter: "All",
            personID: userID
          ),
          userName: name,
          viewType: "Comments"
        )
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
  }

  var savedPostsAndCommentsSection: some View {
    Section {
      NavigationLink {
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
      } label: {
        Label {
          Text("Saved Posts")

        } icon: {
          Image(systemSymbol: .star)
            .foregroundStyle(.yellow)
        }
      }
      NavigationLink {
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
      } label: {
        Label {
          Text("Saved Comments")

        } icon: {
          Image(systemSymbol: .starBubble)
            .foregroundStyle(.orange)
        }
      }
    }
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
    .listRowBackground(Rectangle().shiny(.iridescent))
  }
}

struct AccountTabView_Previews: PreviewProvider {
  static var previews: some View {
    MyUserView()
  }
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
          .foregroundStyle(.gray)
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

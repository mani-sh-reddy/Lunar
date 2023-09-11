//
//  MyUserView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import NukeUI
import SwiftUI

struct MyUserView: View {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedUser") var selectedUser = Settings.selectedUser

//  var selectedAccount: AccountModel {
//    print("loggedInAccounts \(loggedInAccounts)")
//    for account in loggedInAccounts {
//      if account.actorID == selectedActorID {
//        return account
//      } else {
//        return AccountModel(
//          userID: "",
//          name: "",
//          email: "",
//          avatarURL: "",
//          actorID: ""
//        )
//      }
//    }
//    return AccountModel(
//      userID: "",
//      name: "",
//      email: "",
//      avatarURL: "",
//      actorID: ""
//    )
//  }

  var myAccount: AccountModel {
    if !selectedUser.isEmpty {
      print(selectedUser)
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

  var avatar: String { return myAccount.avatarURL }
  var actorID: String { return myAccount.actorID }
  var name: String { return myAccount.name }
  var postScore: String { return String(myAccount.postScore) }
  var commentScore: String { return String(myAccount.commentScore) }
  var postCount: String { return String(myAccount.postCount) }
  var commentCount: String { return String(myAccount.commentCount) }

  var userInstance: String {
    if !actorID.isEmpty {
      return "@\(URLParser.extractDomain(from: actorID))"
    } else {
      return "Login to view"
    }
  }

  var body: some View {
    List {
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
              Image(systemName: "person.circle.fill")
                .resizable()
                .symbolRenderingMode(.hierarchical)
            }
          }
          .processors([.resize(width: 100)])
          .frame(width: 150, height: 150)
//          .padding(.top, 10)
          .padding(.bottom, 10)
          Spacer()
        }
        HStack {
          Spacer()
          userInfo
          Spacer()
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
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
      Section {
        HStack {
          GeneralCommunityQuicklinkButton(
            image: "list.bullet.circle.fill",
            hexColor: "bbbbbb",
            title: "Posts",
            brightness: 0.2,
            saturation: 0
          )
          Spacer()
          Text(postCount)
            .font(.headline)
            .foregroundStyle(.gray)
        }

        HStack {
          GeneralCommunityQuicklinkButton(
            image: "bubble.left.circle.fill",
            hexColor: "bbbbbb",
            title: "Comments",
            brightness: 0.2,
            saturation: 0
          )
          Spacer()
          Text(commentCount)
            .font(.headline)
            .foregroundStyle(.gray)
        }

        GeneralCommunityQuicklinkButton(
          image: "folder.circle.fill",
          hexColor: "bbbbbb",
          title: "Saved",
          brightness: 0.2,
          saturation: 0
        )
      }
    }
    .listStyle(.insetGrouped)
    .onAppear {
      if let jwt = JWT().getJWTFromKeychain(actorID: selectedActorID) {
        SiteInfoFetcher(jwt: jwt).fetchSiteInfo { _, _, _, _ in }
      }
    }
  }

  var userInfo: some View {
    VStack {
      Text(name)
        .font(.largeTitle).bold()
        .padding(2)
      Text(userInstance)
        .font(.title2).bold()
        .foregroundStyle(.secondary)
        .padding(2)
    }
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

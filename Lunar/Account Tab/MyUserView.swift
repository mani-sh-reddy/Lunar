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
  var userInstance: String { "@\(URLParser.extractDomain(from: actorID))" }

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
            }else {
                Image(systemName: "person.crop.circle.fill")
                  .resizable()
                  .symbolRenderingMode(.hierarchical)
              }
          }
          .frame(width: 150, height: 150)
          .padding(.top, 20)
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
    }
    .listStyle(.insetGrouped)
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

//
//  KbinNavLink.swift
//  Lunar
//
//  Created by Mani on 11/12/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct KbinNavLink: View {
//  @Default(.activeAccount) var activeAccount
  @Default(.kbinSelectedInstance) var kbinSelectedInstance

  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts
  @ObservedResults(RealmPage.self) var realmPage

  let realm = try! Realm()

  var body: some View {
    NavigationLink {
      PostsView(
        realmPage: realmPage.sorted(byKeyPath: "timestamp", ascending: false).first(where: {
          $0.sort == "active"
            && $0.type == "1d"
            && $0.filterKey == "KBIN_GENERAL"
        }) ?? RealmPage(),
        filteredPosts: realmPosts.filter { post in
          post.sort == "active"
            && post.type == "1d"
            && post.filterKey == "KBIN_GENERAL"
        },
        sort: "active",
        type: "1d",
        user: 0,
        communityID: 0,
        personID: 0,
        filterKey: "KBIN_GENERAL",
        heading: "Kbin",
        isKbin: true
      )
    } label: {
      HStack {
        Image("KbinSymbolSpace")
          .resizable()
          .frame(width: 30, height: 30)
          .symbolRenderingMode(.hierarchical)

        Text(kbinSelectedInstance)
          .padding(.horizontal, 10)
      }
    }
  }
}

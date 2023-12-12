//
//  KbinNavLink.swift
//  Lunar
//
//  Created by Mani on 11/12/2023.
//

import Alamofire
import Defaults
import Foundation
import MarkdownUI
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

//// TODO: - TEMPORARY
// struct KbinNavLinkTemp: View {
//  @Default(.kbinSelectedInstance) var kbinSelectedInstance
//
//  @StateObject var kbinPostsFetcher = KbinPostsFetcherTemp(
//    sort: "active",
//    time: "1w",
//    page: 1,
//    filterKey: "KBIN_TEMP"
//  )
//
//  let realm = try! Realm()
//
//  var body: some View {
//    NavigationLink {
//      List {
//        Markdown {
//          CodeBlock(language: "json") {
//            String(kbinPostsFetcher.jsonString)
//          }
//        }
//        .markdownTheme(.gitHub)
//      }
//      .navigationTitle("API Response")
//    } label: {
//      HStack {
//        Image("KbinSymbolSpace")
//          .resizable()
//          .frame(width: 30, height: 30)
//          .symbolRenderingMode(.hierarchical)
//
//        Text(kbinSelectedInstance)
//          .padding(.horizontal, 10)
//      }
//    }
//    .onAppear {
//      kbinPostsFetcher.loadContent()
//    }
//  }
// }
//
// class KbinPostsFetcherTemp: ObservableObject {
//  @Default(.activeAccount) var activeAccount
//  @Default(.kbinSelectedInstance) var kbinSelectedInstance
//
//  @Published var isLoading = false
//  @Published var jsonString = ""
//
//  var sort: String?
//  var time: String?
//  var magazine: String?
//  var instance: String?
//  var filterKey: String
//  var endpointPath: String
//
//  @State private var page: Int = 1
//
//  private var parameters: KbinEndpointParameters {
//    KbinEndpointParameters(
//      endpointPath: endpointPath,
//      page: page,
//      sort: sort,
//      time: time,
//      magazine: magazine,
//      instance: instance
//    )
//  }
//
//  init(
//    sort: String?,
//    time: String?,
//    //    magazine: String?,
//    instance: String? = nil,
//    page: Int,
//    filterKey: String
//  ) {
//    endpointPath = "/api/posts"
//
//    self.page = page
//    self.sort = sort
//    self.time = time
//    self.instance = instance
//    //    self.magazine = magazine
//    self.filterKey = filterKey
//  }
//
//  func loadContent(isRefreshing _: Bool = false) {
//    guard !isLoading else { return }
//
//    isLoading = true
//
//    let cacher = ResponseCacher(behavior: .doNotCache)
//
//    AF.request(
//      KbinEndpointBuilder(parameters: parameters).build()
//    )
//    .cacheResponse(using: cacher)
//    .validate(statusCode: 200 ..< 300)
//    .response { response in
//
//      switch response.result {
//      case let .success(result):
//
//        self.jsonString = String(decoding: result ?? Data(), as: UTF8.self)
//        self.isLoading = false
//
//      case let .failure(error):
//        print("KbinPostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
//        self.isLoading = false
//      }
//    }
//  }
// }

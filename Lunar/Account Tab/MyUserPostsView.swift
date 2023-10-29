//
//  MyUserPostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SwiftUI

struct MyUserPostsView: View {
  @Default(.forcedPostSort) var forcedPostSort
  @Default(.selectedInstance) var selectedInstance
  @Default(.postsViewStyle) var postsViewStyle

  var personFetcher: PersonFetcher

  var heading: String

  var listStyle: String {
    if postsViewStyle == "compactPlain" {
      "plain"
    } else {
      postsViewStyle
    }
  }

  var body: some View {
    List {
      ForEach(personFetcher.posts, id: \.post.id) { post in
        LegacyPostSectionView(post: post)
          .onAppear {
            if post.post.id == personFetcher.posts.last?.post.id {
              personFetcher.loadContent()
            }
          }
      }
      if personFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      personFetcher.loadContent(isRefreshing: true)
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .onChange(of: forcedPostSort) { _ in
      withAnimation {
        personFetcher.sortParameter = forcedPostSort.rawValue
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        SortTypePickerView(sortType: $forcedPostSort)
      }
    }
    .navigationTitle(heading)
    .navigationBarTitleDisplayMode(.inline)
    .modifier(ConditionalListStyleModifier(listStyle: listStyle))
  }
}

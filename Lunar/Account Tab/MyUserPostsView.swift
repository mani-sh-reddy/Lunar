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
  @Default(.legacyPostsViewStyle) var legacyPostsViewStyle

  var personFetcher: PersonFetcher

  var heading: String

  var listStyle: String {
    if legacyPostsViewStyle == "compactPlain" {
      "plain"
    } else {
      legacyPostsViewStyle
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
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
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

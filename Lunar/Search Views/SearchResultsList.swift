//
//  SearchResultsList.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct SearchResultsList: View {
  @Default(.searchSortType) var searchSortType
  @StateObject var searchFetcher: SearchFetcher

  @State var isLoading: Bool = false

  @Binding var searchText: String
  @Binding var selectedSearchType: String
  //  @Binding var selectedSortType: String
//  @AppStorage("selectedSearchSortType") var selectedSearchSortType = Settings.selectedSearchSortType

  var selectedSearchTypeIcon: (SFSafeSymbols.SFSymbol, Color) {
    switch selectedSearchType {
    case "Users":
      (.personCircleFill, Color.blue)
    case "Communities":
      (.booksVerticalCircleFill, Color.teal)
    case "Posts":
      (.rectangleOnRectangleCircleFill, Color.purple)
    default:
      (.magnifyingglassCircleFill, Color.gray)
    }
  }

  var body: some View {
    Section {
      if isLoading {
        /// Needed to give ProgressView it's own identifier otherwise
        /// the list row would show even after ProgressView is removed
        ProgressView().id(UUID())
      } else {
        switch selectedSearchType {
        case "Users":
          SearchUsersRowView(searchUsersResults: searchFetcher.users)
        case "Communities":
          SearchCommunitiesRowView(searchCommunitiesResults: searchFetcher.communities)
        case "Posts":
          ForEach(searchFetcher.posts, id: \.post.id) { post in
            NavigationLink {
              NonRealmCommentsView(
                commentsFetcher: CommentsFetcher(postID: post.post.id),
                post: post
              )
            } label: {
              Text(post.post.name)
            }
          }
        default:
          EmptyView()
        }
      }
      NavigationLink(
        destination: {
//          SearchUsersListAll()
          PlaceholderView()
        },
        label: {
          Label {
            if !searchText.isEmpty {
              Text("More \(selectedSearchType) with \"\(searchText)\"")
            } else {
              Text("Trending \(selectedSearchType)")
            }
          } icon: {
            Image(systemSymbol: selectedSearchTypeIcon.0)
              .resizable()
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.hierarchical)

          }.foregroundStyle(selectedSearchTypeIcon.1)
        }
      )
    }
    .onChange(of: searchSortType) { _ in
      withAnimation {
        searchFetcher.sortParameter = searchSortType.rawValue
        searchFetcher.loadMoreContent { completed, _ in
          isLoading = !completed
        }
      }
    }
    .onDebouncedChange(of: $searchText, debounceFor: 0.1) { newValue in
      if newValue.isEmpty {
        withAnimation {
          isLoading = false
        }
      } else {
        withAnimation {
          isLoading = true
        }
      }
    }
    .onDebouncedChange(of: $searchText, debounceFor: 1) { query in
      withAnimation {
        searchFetcher.searchQuery = query
        searchFetcher.loadMoreContent { completed, _ in
          isLoading = !completed
        }
      }
    }
    .onDebouncedChange(of: $selectedSearchType, debounceFor: 0.1) { _ in
      withAnimation {
        if !$searchText.wrappedValue.isEmpty {
          isLoading = true
        }
      }
    }
    .onDebouncedChange(of: $selectedSearchType, debounceFor: 1) { query in
      withAnimation {
        searchFetcher.typeParameter = query
        searchFetcher.loadMoreContent { completed, _ in
          isLoading = !completed
        }
      }
    }
  }
}

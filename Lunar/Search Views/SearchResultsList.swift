//
//  SearchResultsList.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import SwiftUI

struct SearchResultsList: View {
  @StateObject var searchFetcher: SearchFetcher

  @State var isLoading: Bool = false

  @Binding var searchText: String
  @Binding var selectedSearchType: String
  //  @Binding var selectedSortType: String
  @AppStorage("selectedSearchSortType") var selectedSearchSortType = Settings.selectedSearchSortType

  var selectedSearchTypeIcon: (String, Color) {
    switch selectedSearchType {
    case "Users":
      return ("person.circle.fill", Color.blue)
    case "Communities":
      return ("books.vertical.circle.fill", Color.teal)
    case "Posts":
      return ("signpost.right.circle.fill", Color.purple)
    default:
      return ("magnifyingglass.circle.fill", Color.gray)
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
            Text(post.post.name)
          }
        default:
          EmptyView()
        }
      }
      NavigationLink(
        destination: {
          SearchUsersListAll()
        },
        label: {
          Label {
            if !searchText.isEmpty {
              Text("More \(selectedSearchType) with \"\(searchText)\"")
            } else {
              Text("Trending \(selectedSearchType)")
            }
          } icon: {
            Image(systemName: selectedSearchTypeIcon.0)
              .resizable()
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.hierarchical)

          }.foregroundStyle(selectedSearchTypeIcon.1)
        })
    }
    .onChange(of: selectedSearchSortType) { query in
      withAnimation {
        searchFetcher.sortParameter = query
        searchFetcher.loadMoreContent { completed, _ in
          isLoading = !completed
        }
      }
    }
    .onDebouncedChange(of: $searchText, debounceFor: 0) { newValue in
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
    .onDebouncedChange(of: $selectedSearchType, debounceFor: 0) { _ in
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

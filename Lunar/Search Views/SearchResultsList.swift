//
//  SearchResultsList.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct SearchResultsList: View {
    @StateObject var searchFetcher: SearchFetcher

    @Binding var searchText: String
    @Binding var selectedSearchType: String

    var selectedSearchTypeIcon: String {
        switch selectedSearchType {
        case "Users":
            return "person.fill"
        case "Communities":
            return "person.3.sequence.fill"
        case "Posts":
            return "photo.stack.fill"
        default:
            return "magnifyingglass"
        }
    }

    var body: some View {
        Section {
            if searchFetcher.isLoading {
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
//                ForEach(searchFetcher.users, id: \.person.id) { person in
//                    Text(person.person.name)
//                }
            }
            if searchFetcher.isLoading {
                ProgressView()
            } else {
                NavigationLink(destination: {
                    SearchUsersListAll()
                }, label: {
                    Group {
                        if searchText != "" {
                            Text("More \(selectedSearchType) with \"\(searchText)\"")
                        } else {
                            Text("Trending")
                        }
                    }
                    .foregroundStyle(.blue)
                })
            }

        } header: {
            Label(
                title: { Text(selectedSearchType) },
                icon: {
                    Image(systemName: selectedSearchTypeIcon)
                        .symbolRenderingMode(.hierarchical)
                }
            ).padding(.bottom, 5)
        }
        .onDebouncedChange(of: $searchText, debounceFor: 0) { _ in
            withAnimation {
                print(searchFetcher.isLoading)
            }
        }
        .onDebouncedChange(of: $searchText, debounceFor: 1) { query in
            withAnimation {
                searchFetcher.searchQuery = query
                searchFetcher.loadMoreContent()
                print(searchFetcher.isLoading)
            }
        }
        .onDebouncedChange(of: $selectedSearchType, debounceFor: 0) { query in
            withAnimation {
                searchFetcher.typeParameter = query
                searchFetcher.loadMoreContent()
            }
        }
    }
}


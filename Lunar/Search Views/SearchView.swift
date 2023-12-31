//
//  SearchView.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct SearchView: View {
  @Default(.searchSortType) var searchSortType
  @Default(.debugModeEnabled) var debugModeEnabled

  @State var searchText: String = ""
  @State var selectedSearchType: String = "Users"

  var body: some View {
    NavigationView {
      List {
        if debugModeEnabled {
          Text("selectedSortType: \(searchSortType.rawValue)")
        }
        Section {
          SearchResultsList(
            searchFetcher: SearchFetcher(
              searchQuery: "",
              sortParameter: searchSortType.rawValue,
              typeParameter: selectedSearchType,
              limitParameter: 50,
              clearListOnChange: true
            ),
            searchText: $searchText,
            selectedSearchType: $selectedSearchType
          )
        } header: {
          HStack(alignment: .center) {
            Picker(
              "Search Type", selection: $selectedSearchType,
              content: {
                Image(systemSymbol: .personFill).tag("Users")
                Image(systemSymbol: .booksVerticalFill).tag("Communities")
                Image(systemSymbol: .rectangleFillOnRectangleFill).tag("Posts")
              }
            )
            .textCase(.none)
            .pickerStyle(.segmented)
            SortPicker(sortType: $searchSortType)
              .labelStyle(.iconOnly)
              .frame(width: 80, alignment: .trailing)

          }.padding(.bottom, 10)
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Search \(selectedSearchType)"
    )
    .keyboardType(.default)
    .autocorrectionDisabled()
    .textInputAutocapitalization(.never)
  }
}

#Preview {
  SearchView(searchText: "")
}

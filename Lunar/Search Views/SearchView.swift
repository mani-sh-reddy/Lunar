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
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
//  @AppStorage("selectedSearchSortType") var selectedSearchSortType = Settings.selectedSearchSortType

  @State var searchText: String = ""
  @State var selectedSearchType: String = "Users"
  //  @State var selectedSortType: String = "Active"

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
                Image(systemSymbol: .signpostRightFill).tag("Posts")
              }
            )
            .textCase(.none)
            .pickerStyle(.segmented)
            SortTypePickerView(sortType: $searchSortType)
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

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(searchText: "")
  }
}

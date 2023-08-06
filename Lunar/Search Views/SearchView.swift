//
//  SearchView.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @State var selectedSearchType: String = "Users"

    var body: some View {
        NavigationView {
            List {
                Picker("Search Type", selection: $selectedSearchType, content: {
                    Text("Users").tag("Users")
                    Text("Communities").tag("Communities")
                    Text("Posts").tag("Posts")
                })
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)

                SearchResultsList(
                    searchFetcher: SearchFetcher(
                        searchQuery: "",
                        typeParameter: selectedSearchType,
                        limitParameter: 50,
                        clearListOnChange: true
                    ),
                    searchText: $searchText,
                    selectedSearchType: $selectedSearchType
                )
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Search \(selectedSearchType)")
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

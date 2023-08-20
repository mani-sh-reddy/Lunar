//
//  SearchView.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import SwiftUI

struct SearchView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("selectedSearchSortType") var selectedSearchSortType = Settings.selectedSearchSortType
  
  @State var searchText: String = ""
  @State var selectedSearchType: String = "Users"
//  @State var selectedSortType: String = "Active"

  var body: some View {
    NavigationView {
      List {
        if debugModeEnabled {
          Text("selectedSortType: \(selectedSearchSortType)")
        }
        Section {
          SearchResultsList(
            searchFetcher: SearchFetcher(
              searchQuery: "",
              sortParameter: selectedSearchSortType,
              typeParameter: selectedSearchType,
              limitParameter: 50,
              clearListOnChange: true
            ),
            searchText: $searchText,
            selectedSearchType: $selectedSearchType
          )
        } header: {
          HStack (alignment: .center) {
            Picker(
              "Search Type", selection: $selectedSearchType,
              content: {
                Image(systemName: "person.fill").tag("Users")
                Image(systemName: "books.vertical.fill").tag("Communities")
                Image(systemName: "signpost.right.fill").tag("Posts")
              }
            )
            .textCase(.none)
            .pickerStyle(.segmented)
            
            
            Picker("Sort Type", selection: $selectedSearchSortType,
              content: {
                Group {
                  Label{Text("Active")} icon: {Image(systemName: "chart.line.uptrend.xyaxis")}.tag("Active")
                  Label{Text("Hot")} icon: {Image(systemName: "flame.fill")}.tag("Hot")
                  Label{Text("New")} icon: {Image(systemName: "sparkles")}.tag("New")
                  Label{Text("Top Day")} icon: {Image(systemName: "d.circle")}.tag("TopDay")
                  Label{Text("Top Week")} icon: {Image(systemName: "w.circle")}.tag("TopWeek")
                  Label{Text("Top Month")} icon: {Image(systemName: "m.circle")}.tag("TopMonth")
                  Label{Text("Top Year")} icon: {Image(systemName: "y.circle")}.tag("TopYear")
                  Label{Text("Top All")} icon: {Image(systemName: "text.line.first.and.arrowtriangle.forward")}.tag("TopAll")
                  Label{Text("Most Comments")} icon: {Image(systemName: "star.bubble")}.tag("MostComments")
                }
                .textCase(.lowercase)
              }
            )
            
            .frame(width: 80, alignment: .trailing)
            .pickerStyle(.menu)
            .labelStyle(.iconOnly)
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

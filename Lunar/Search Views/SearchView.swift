//
//  SearchView.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import SFSafeSymbols
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

            Picker(
              "Sort Type", selection: $selectedSearchSortType,
              content: {
                Group {
                  Label {
                    Text("Active")
                  } icon: {
                    Image(systemSymbol: .chartLineUptrendXyaxis)
                  }.tag("Active")
                  Label {
                    Text("Hot")
                  } icon: {
                    Image(systemSymbol: .flameFill)
                  }.tag("Hot")
                  Label {
                    Text("New")
                  } icon: {
                    Image(systemSymbol: .sparkles)
                  }.tag("New")
                  Label {
                    Text("Top Day")
                  } icon: {
                    Image(systemSymbol: .dCircle)
                  }.tag("TopDay")
                  Label {
                    Text("Top Week")
                  } icon: {
                    Image(systemSymbol: .wCircle)
                  }.tag("TopWeek")
                  Label {
                    Text("Top Month")
                  } icon: {
                    Image(systemSymbol: .mCircle)
                  }.tag("TopMonth")
                  Label {
                    Text("Top Year")
                  } icon: {
                    Image(systemSymbol: .yCircle)
                  }.tag("TopYear")
                  Label {
                    Text("Top All")
                  } icon: {
                    Image(systemSymbol: .arrowUpCircle)
                  }.tag("TopAll")
                  Label {
                    Text("Most Comments")
                  } icon: {
                    Image(systemSymbol: .starBubble)
                  }.tag("MostComments")
                }
                .textCase(.none)
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

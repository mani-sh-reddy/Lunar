//
//  MyUserObserver.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SwiftUI

struct MyUserObserver: View {
  @Default(.forcedPostSort) var forcedPostSort
  @Default(.selectedInstance) var selectedInstance
  @Default(.postsViewStyle) var postsViewStyle

  /// Experimenting using ObservedObject instead of StateObject
  @ObservedObject var personFetcher: PersonFetcher

  var userName: String
  var viewType: String

  var heading: String {
    if userName.isEmpty {
      "User's \(viewType)"
    } else {
      "\(userName)'s \(viewType)"
    }
  }

  var body: some View {
    switch viewType {
    case "Posts":
      MyUserPostsView(personFetcher: personFetcher, heading: heading)
    case "Comments":
      MyUserCommentsView(personFetcher: personFetcher, heading: heading)
    case "Saved Posts":
      MyUserPostsView(personFetcher: personFetcher, heading: heading)
    case "Saved Comments":
      MyUserCommentsView(personFetcher: personFetcher, heading: heading)
    default:
      PlaceholderView()
    }
  }
}

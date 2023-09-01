//
//  CommunityHeaderView.swift
//  Lunar
//
//  Created by Mani on 13/08/2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct CommunityHeaderView: View {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @State private var bannerFailedToLoad = false
  @State private var iconFailedToLoad = false

  var community: CommunityObject?
  var navigationHeading: String { return community?.community.name ?? "" }
  var communityDescription: String? { return community?.community.description }
  var communityActorID: String { return community?.community.actorID ?? "" }

  var hasBanner: Bool {
    community?.community.banner != "" && community?.community.banner != nil  // skipcq: SW-P1006
  }
  var hasIcon: Bool {
    community?.community.icon != "" && community?.community.icon != nil  // skipcq: SW-P1006
  }
  var body: some View {
    Section {
      HStack {
        if hasIcon, !iconFailedToLoad {
          KFImage(URL(string: community?.community.icon ?? ""))
            .fade(duration: 0.25)
            .resizable()
            .onFailure { _ in
              iconFailedToLoad = true
            }
            .clipped()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width: 60, height: 60)
            .padding(5)
            .border(debugModeEnabled ? Color.red : Color.clear)
        } else {
          EmptyView()
            .frame(width: 0, height: 0)
        }
        VStack(alignment: .leading) {
          Text(navigationHeading)
            .font(.title).bold()
          Text("@\(URLParser.extractDomain(from: communityActorID))").font(.headline)
        }
      }
      .border(debugModeEnabled ? Color.purple : Color.clear)

      if let description = communityDescription {
        Text(LocalizedStringKey(description))
      }
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}

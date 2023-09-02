////
////  CommunityHeaderView.swift
////  Lunar
////
////  Created by Mani on 13/08/2023.
////
//
// import Foundation
// import SwiftUI
// import Nuke
// import NukeUI
//
// struct CommunityHeaderView: View {
//  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
//  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
//  @State private var bannerFailedToLoad = false
//
//  var community: CommunityObject?
//  var navigationHeading: String { return community?.community.name ?? "" }
//  var communityDescription: String? { return community?.community.description }
//  var communityActorID: String { return community?.community.actorID ?? "" }
//
//  var hasBanner: Bool {
//    community?.community.banner != "" && community?.community.banner != nil  // skipcq: SW-P1006
//  }
//  var hasIcon: Bool {
//    community?.community.icon != "" && community?.community.icon != nil  // skipcq: SW-P1006
//  }
//  var body: some View {
//    Section {
//      HStack {
//        if hasIcon {
//
//          LazyImage(url: URL(string: (community?.community.icon) ?? "")) { state in
//            if let image = state.image {
//              image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .clipShape(Circle())
//                .frame(width: 60, height: 60)
//                .padding(5)
//                .border(debugModeEnabled ? Color.red : Color.clear)
//            } else if state.error != nil {
//              EmptyView()
//            } else {
//              Color.clear // Acts as a placeholder
//            }
//          }
//          .processors([.resize(width: 60)])
//          //          .clipShape(RoundedRectangle(cornerRadius: imageRadius, style: .continuous))
//        }
//
//        VStack(alignment: .leading) {
//          Text(navigationHeading)
//            .font(.title).bold()
//          Text("@\(URLParser.extractDomain(from: communityActorID))").font(.headline)
//        }
//      }
//      .border(debugModeEnabled ? Color.purple : Color.clear)
//
//      if let description = communityDescription {
//        Text(LocalizedStringKey(description))
//      }
//    }
//    .listRowSeparator(.hidden)
//    .listRowBackground(Color.clear)
//  }
// }

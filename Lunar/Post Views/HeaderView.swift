//
//  HeaderView.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//

import Foundation
import NukeUI
import SwiftUI

struct HeaderView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @State private var bannerFailedToLoad = false
  @State private var iconFailedToLoad = false

  var navigationHeading: String
  var description: String?
  var actorID: String
  var banner: String?
  var icon: String?

  var body: some View {
    Section {
      HStack {

        LazyImage(url: URL(string: icon ?? "")) { state in
          if let image = state.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .clipShape(Circle())
              .frame(width: 60, height: 60)
          } else if state.error != nil {
            Color.clear.frame(width: 0, height: 60)
          } else {
            Color.clear.frame(width: 0, height: 60)
          }
        }
        .padding(5)

        VStack(alignment: .leading) {
          Text(navigationHeading)
            .font(.title).bold()
          Text("@\(URLParser.extractDomain(from: actorID))").font(.headline)
        }
      }

      .border(debugModeEnabled ? Color.purple : Color.clear)

      if let description = description {
        Text(LocalizedStringKey(description))
      }
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}

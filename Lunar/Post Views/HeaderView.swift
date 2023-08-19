//
//  HeaderView.swift
//  Lunar
//
//  Created by Mani on 19/08/2023.
//


import Foundation
import Kingfisher
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
        if (icon != nil), !iconFailedToLoad {
          KFImage(URL(string: icon ?? ""))
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

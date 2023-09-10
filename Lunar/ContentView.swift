//
//  ContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import PulseUI
import SwiftUI

struct ContentView: View {
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled
  @AppStorage("prominentInspectorButton") var prominentInspectorButton = Settings.prominentInspectorButton

  @State private var networkInspectorPopover: Bool = false

  init() {
    if #available(iOS 15, *) {
      let tabBarAppearance: UITabBarAppearance = .init()
      tabBarAppearance.configureWithDefaultBackground()
      UITabBar.appearance().standardAppearance = tabBarAppearance
      UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
  }

  var body: some View {
    TabView {
      FeedView()
        .tabItem {
          Label("Feed", systemImage: "mail.stack")
        }
      PlaceholderView()
        .tabItem {
          Label("Inbox", systemImage: "tray")
        }
      MyUserView()
        .tabItem {
          Label("Account", systemImage: "person")
        }
      SearchView()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape.fill")
        }
    }
    .overlay(alignment: .bottomTrailing) {
      if networkInspectorEnabled && prominentInspectorButton {
        Button {
          networkInspectorPopover = true
        } label: {
          Label("Inspector", systemImage: "rectangle.and.text.magnifyingglass")
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(.orange)
            .foregroundColor(.white)
            .mask {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
        }
        .padding(20)
        .padding(.bottom, 40)
      }
    }
    .popover(isPresented: $networkInspectorPopover) {
      NavigationView {
        ConsoleView()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

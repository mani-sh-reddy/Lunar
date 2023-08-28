//
//  ContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct ContentView: View {
  let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
  
  init() {
    if #available(iOS 15, *) {
      let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
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
      PlaceholderView()
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

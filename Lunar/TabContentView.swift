//
//  TabContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Defaults
import PulseUI
import SFSafeSymbols
import SwiftUI

struct TabContentView: View {
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.prominentInspectorButton) var prominentInspectorButton

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
          Label("Feed", systemSymbol: .mailStack)
        }
      InboxView()
        .tabItem {
          Label("Inbox", systemSymbol: .tray)
        }
      MyUserView()
        .tabItem {
          Label("Account", systemSymbol: .person)
        }
      SearchView()
        .tabItem {
          Label("Search", systemSymbol: .magnifyingglass)
        }
      SettingsView()
        .tabItem {
          Label("Settings", systemSymbol: .gearshape)
        }
    }
    .overlay(alignment: .bottomTrailing) {
      if networkInspectorEnabled, prominentInspectorButton {
        DraggableView {
          Image(systemSymbol: .rectangleAndTextMagnifyingglass)
            .font(.title2)
            .padding(15)
            .foregroundColor(.white)
            .background(Color.orange)
            .clipShape(Circle())
            .padding(20)
            .padding(.bottom, 50)
            .shadow(radius: 5)
            .highPriorityGesture(
              TapGesture().onEnded {
                networkInspectorPopover = true
              }
            )
        }
      }
    }
    .popover(isPresented: $networkInspectorPopover) {
      NavigationView {
        ConsoleView()
      }
    }
  }
}

struct TabContentView_Previews: PreviewProvider {
  static var previews: some View {
    TabContentView()
  }
}

//
//  ContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State var lemmyInstance: String = "lemmy.world"
    @State private var tabSelection = 0

    var body: some View {
        TabView(selection: $tabSelection) {
            FeedView(lemmyInstance: $lemmyInstance)
                .badge(0)
                .tabItem {
                    Label("Feed", systemImage: "list.bullet.rectangle")
                }
            PlaceholderView()
                .tabItem {
                    Label("Inbox", systemImage: "tray")
                }
            PlaceholderView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            PlaceholderView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView(lemmyInstance: $lemmyInstance)
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

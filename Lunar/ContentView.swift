//
//  ContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
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
            PlaceholderView()
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

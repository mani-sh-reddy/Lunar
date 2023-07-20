//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
    @Binding var lemmyInstance: String
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feed")) {
                    GeneralCommunitiesView()
                }
                Section(header: Text("Trending")) {
                    TrendingCommunitiesView(trendingCommunitiesFetcher: TrendingCommunitiesFetcher(sortParameter: "Hot", limitParameter: "5"))
                }
                Section(header: Text("Subscribed")) {
                    SubscribedCommunitiesView()
                }
            }
            .navigationTitle(lemmyInstance)
        }
        .onAppear {
            networkMonitor.checkConnection()
        }
        .overlay(alignment: .bottom) {
            if networkMonitor.connected {
                EmptyView()
            } else {
                NoInternetConnectionView()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    @State static var lemmyInstance: String = "lemmy.world"

    static var previews: some View {
        FeedView(lemmyInstance: $lemmyInstance)
    }
}

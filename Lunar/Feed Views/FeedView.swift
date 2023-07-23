//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
    @AppStorage("instanceHostURL") var instanceHostURL = DefaultSettings.instanceURL
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feed")) {
                    AggregatedCommunitiesSectionView()
                }
                Section(header: Text("Trending")) {
                    TrendingCommunitiesSectionView(trendingCommunitiesFetcher: TrendingCommunitiesFetcher())
                }
                Section(header: Text("Subscribed")) {
                    SubscribedCommunitiesSectionView()
                }
            }
            .navigationTitle(instanceHostURL)
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
    static var previews: some View {
        FeedView()
    }
}

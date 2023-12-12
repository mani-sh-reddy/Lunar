//
//  LegacyKbinThreadsView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Defaults
import SwiftUI

struct LegacyKbinThreadsView: View {
  @Default(.legacyKbinSelectedInstance) var legacyKbinSelectedInstance

  @StateObject var kbinThreadsFetcher: LegacyKbinThreadsFetcher

  var body: some View {
    List {
      ForEach(kbinThreadsFetcher.posts, id: \.id) { post in
        Section {
          ZStack {
            LegacyKbinPostRowView(post: post)
            NavigationLink {
              LegacyKbinCommentsView(post: post, postURL: "https://\(legacyKbinSelectedInstance)\(post.postURL)")
            } label: {
              EmptyView()
            }
            .opacity(0)
          }
        }
        .task {
          kbinThreadsFetcher.loadMoreContentIfNeeded(currentItem: post)
        }
      }
      if kbinThreadsFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      await kbinThreadsFetcher.refreshContent()
    }
    .navigationTitle("kbin.social")
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
  }
}

#Preview {
  LegacyKbinThreadsView(kbinThreadsFetcher: LegacyKbinThreadsFetcher())
}

//
//  KbinThreadsView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Kingfisher
import SwiftUI

struct KbinThreadsView: View {
    @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL
    @StateObject var kbinThreadsFetcher: KbinThreadsFetcher

    @State var postURL: String = ""

    var body: some View {
        List {
            if kbinThreadsFetcher.isLoading {
                ProgressView().id(UUID())
            } else {
                ForEach(kbinThreadsFetcher.posts, id: \.id) { post in
                    Section {
                        ZStack {
                            KbinPostRowView(post: post)
                            NavigationLink {
                                KbinCommentsView(postURL: "https://\(kbinHostURL)\(post.postURL)")
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                    }
                    .task {
                        kbinThreadsFetcher.loadMoreContentIfNeeded(currentItem: post)
                        postURL = post.postURL
                    }
                }
            }
        }
        .refreshable {
            await kbinThreadsFetcher.refreshContent()
        }
        .navigationTitle("Kbin")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.grouped)
    }
}

struct KbinThreadsView_Previews: PreviewProvider {
    static var previews: some View {
        /// need to set showing popover to a constant value
        KbinThreadsView(kbinThreadsFetcher: KbinThreadsFetcher())
    }
}

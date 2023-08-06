//
//  KbinPostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct KbinPostRowView: View {
    var post: KbinPost

    @State var showingPlaceholderAlert = false

    @State var upvoted: Bool = false
    @State var downvoted: Bool = false

    let haptics = UIImpactFeedbackGenerator(style: .rigid)

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
                .multilineTextAlignment(.leading)

            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(String(post.magazine))
                if post.instanceLink != "" {
                    Text(String("@\(post.instanceLink ?? "")"))
                        .foregroundStyle(.gray).opacity(0.8)
                }
                Spacer()
                Text(String(post.timeAgo)
                    .replacingOccurrences(of: "minute", with: "min")
                    .replacingOccurrences(of: "hour", with: "h")
                )
                .font(.caption)
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .lineLimit(1)
            }
            .lineLimit(1)
            .font(.subheadline)
            .padding(.vertical, 1)

            if post.imageUrl != "" {
                InPostThumbnailView(thumbnailURL: post.imageUrl)
            } else {
                EmptyView()
            }

            HStack(spacing: 6) {
                InPostUserView(
                    text: post.userObject?.username ?? "",
                    iconName: "person.crop",
                    userAvatar: post.userObject?.avatarUrl ?? ""
                )
                Spacer(minLength: 20)

                InPostMetadataView(
                    bodyText: String(post.upvotes),
                    iconName: "arrow.up.circle.fill",
                    iconColor: upvoted ? .green : .gray
                )
                .onTapGesture {
                    downvoted = false
                    upvoted.toggle()
                    haptics.impactOccurred()
                }

                InPostMetadataView(
                    bodyText: String(post.commentsCount),
                    iconName: "bubble.left.circle.fill",
                    iconColor: .gray
                )
            }
        }

        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                showingPlaceholderAlert = true
            } label: {
                Image(systemName: "chevron.forward.circle.fill")
            }.tint(.blue)
        }

        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                showingPlaceholderAlert = true
            } label: {
                Image(systemName: "arrow.up.circle")
            }.tint(.green)
            Button {
                showingPlaceholderAlert = true
            } label: {
                Image(systemName: "arrow.down.circle")
            }.tint(.red)
        }

        .contextMenu {
            Menu("Menu") {
                Button {
                    showingPlaceholderAlert = true
                } label: {
                    Text("Coming Soon")
                }
            }

            Button {
                showingPlaceholderAlert = true
            } label: {
                Text("Coming Soon")
            }

            Divider()

            Button(role: .destructive) {
                showingPlaceholderAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

// struct KbinPostRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        KbinPostRowView(post: KbinPost)
//    }
// }

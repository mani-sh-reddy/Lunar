//
//  PostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct PostRowView: View {
    var post: PostElement

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.post.name)
                .font(.headline)
                .multilineTextAlignment(.leading)

            InPostCommunityHeaderView(community: post.community)
                .padding(.vertical, 1)

            if let thumbnailURL = post.post.thumbnailURL {
                InPostThumbnailView(thumbnailURL: thumbnailURL)
            } else if let url = post.post.url, url.isValidExternalImageURL() {
                InPostThumbnailView(thumbnailURL: url)
            } else {
                EmptyView()
            }

            HStack(spacing: 6) {
                InPostUserView(text: post.creator.name, iconName: "person.crop", userAvatar: post.creator.avatar)
                Spacer(minLength: 20)
                InPostMetadataView(bodyText: String(post.counts.upvotes), iconName: "arrow.up", iconColor: .green)
                InPostMetadataView(bodyText: String(post.counts.downvotes), iconName: "arrow.down", iconColor: .red)
                InPostMetadataView(bodyText: String(post.counts.comments), iconName: "text.bubble", iconColor: .gray)
            }
        }
        .contextMenu {
            Menu("This is a menu") {
                Button {
                    print("This is a menu")
                } label: {
                    Text("Do something")
                }
            }
            
            Button {
                print("Something")
            } label: {
                Text("Something")
            }
            
            Divider()
            
            Button(role: .destructive) {
                print("Delete")
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct InPostCommunityHeaderView: View {
    var community: Community

    var body: some View {
        HStack(spacing: 0) {
            ImageViewWithPlaceholder(imageURL: community.icon, placeholderSystemName: "bookmark.square.fill")

            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text(String(community.name))
                Text(String("@\(URLParser.extractDomain(from: community.actorID))"))
                    .foregroundStyle(.gray).opacity(0.8)
            }
            .lineLimit(1)
            .font(.subheadline)
        }
    }
}


struct InPostThumbnailView: View {
    @State private var isLoading = true

    let processor = DownsamplingImageProcessor(size: CGSize(width: 1300, height: 1300))

    var thumbnailURL: String
    var body: some View {
        KFImage(URL(string: thumbnailURL))
            .onProgress { receivedSize, totalSize in
                if receivedSize < totalSize {
                    isLoading = true
                } else {
                    isLoading = false
                }
            }
            .setProcessor(processor)
            .resizable()
            .cancelOnDisappear(true)
            .fade(duration: 0.2)
            .progressViewStyle(.circular)
            .aspectRatio(contentMode: .fit)
            .frame(alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.bottom, 3)
    }
}

struct InPostUserView: View {
    var text: String
    var iconName: String
    var userAvatar: String?

    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ImageViewWithPlaceholder(imageURL: userAvatar, placeholderSystemName: "person.crop.square.fill")

            Text(String(text))
                .foregroundColor(.gray)
                .textCase(.uppercase)
        }
        .font(.subheadline)
        .padding(.trailing, 2)
        .lineLimit(1)
    }
}

struct InPostMetadataView: View {
    var bodyText: String
    var iconName: String
    var iconColor: Color
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(iconColor)
            Text(String(bodyText))
                .foregroundColor(iconColor)
                .textCase(.uppercase)
        }
        .font(.subheadline)
        .padding(.horizontal, 2)
        .lineLimit(1)
    }
}

extension String {
    func isValidExternalImageURL() -> Bool {
        let validURLs = [
            "i.imgur.com",
            "media1.giphy.com",
            "media.giphy.com",
            "files.catbox.moe",
            "i.postimg.cc",
        ]
        for url in validURLs {
            if contains(url) {
                return true
            }
        }
        return false
    }
}

enum URLParser {
    static func extractDomain(from url: String) -> String {
        guard let urlComponents = URLComponents(string: url),
              let host = urlComponents.host
        else {
            return ""
        }

        if let range = host.range(of: #"^(www\.)?([a-zA-Z0-9-]+\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?$"#,
                                  options: .regularExpression)
        {
            return String(host[range])
        }

        return ""
    }
}

struct ImageViewWithPlaceholder: View {
    var imageURL: String?
    var placeholderSystemName: String

    var body: some View {
        let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
        if let url = imageURL, let image = URL(string: url) {
            KFImage(image)
                .setProcessor(processor)
                .placeholder {
                    Image(systemName: placeholderSystemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                }
                .resizable()
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                .scaledToFit()
                .padding(.trailing, 5)
        } else {
            Image(systemName: placeholderSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.gray)
                .padding(.trailing, 5)
        }
    }
}


struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: MockData.post).padding()
    }
}

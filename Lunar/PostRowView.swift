//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI
import Kingfisher

struct PostRowView: View {
    var post: PostElement
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (spacing: 4, content: {
                KFImage(URL(string: post.community.icon ?? ""))
                    .placeholder { Image(systemName: "books.vertical.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                    }
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                Text("\(String(post.community.name))")
                    .font(.subheadline)
                    .padding(.horizontal, 3)
            }).font(.subheadline)
                .padding(.vertical, 3)
            
            Text(post.post.name)
                .font(.headline)
            
            if let thumbnailURL = post.post.thumbnailURL {
                KFImage(URL(string: thumbnailURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else if let url = post.post.url,
                      url.isValidExternalImageURL() {
                KFImage(URL(string: url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                EmptyView() // No view when no valid image URL is available
            }
            
        }
    }
}

struct PostRowFooterView: View {
    var post: PostElement
    
    var body: some View {
        HStack{
            HStack (spacing: 4, content: {
                Text("by")
                Text("\(String(post.creator.name).uppercased())")
                //                    Text("in")
                //                    Text("\(String(post.community.name))").fontWeight(.semibold)
                //                        .fixedSize()
            })
            Spacer()
            HStack (spacing: 2, content: {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                        .font(.subheadline)
                    Text(String(post.counts.upvotes))
                        .foregroundColor(.green)
                }
                
                
                Divider().hidden()
                Divider().hidden()
                
                HStack(spacing: 2) {
                    Image(systemName: "arrow.down")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.red)
                    Text(String(post.counts.downvotes))
                        .foregroundColor(.red)
                }
                
                Divider().hidden()
                Divider().hidden()
                Image(systemName: "bubble.left")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.gray)
                Text(String(post.counts.comments))
                    .foregroundColor(.gray)
            }).fixedSize()
        }
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
            if self.contains(url) {
                return true
            }
        }
        return false
    }
}


struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        let post =
        PostElement(
            post: PostObject(
                id: 1,
                name: "Example Post",
                url: "https://example.com",
                creatorID: 1,
                communityID: 1,
                removed: false,
                locked: false,
                published: "2023-07-06T12:34:56Z",
                deleted: false,
                thumbnailURL: "https://placehold.co/600x400",
                apID: "exampleID",
                local: true,
                languageID: 1,
                featuredCommunity: false,
                featuredLocal: false,
                body: "This is an example post",
                updated: nil,
                embedTitle: nil,
                embedDescription: nil,
                embedVideoURL: nil
            ),
            creator: Creator(
                id: 1,
                name: "JohnDoe",
                displayName: "John Doe",
                avatar: nil,
                banned: false,
                published: "2023-07-06T12:34:56Z",
                actorID: "johnDoeActorID",
                bio: "I'm a user",
                local: true,
                banner: nil,
                deleted: false,
                admin: false,
                botAccount: false,
                instanceID: 1,
                updated: nil,
                matrixUserID: nil
            ),
            community: Community(
                id: 1,
                name: "ExampleCommunity",
                title: "Example Community",
                description: "This is an example community",
                removed: false,
                published: "2023-07-06T12:34:56Z",
                updated: nil,
                deleted: false,
                actorID: "exampleCommunityActorID",
                local: true,
                icon: nil,
                hidden: false,
                postingRestrictedToMods: false,
                instanceID: 1,
                banner: nil
            ),
            creatorBannedFromCommunity: false,
            counts: Counts(
                id: 1,
                postID: 1,
                comments: 5,
                score: 10,
                upvotes: 15,
                downvotes: 5,
                published: "2023-07-06T12:34:56Z",
                newestCommentTimeNecro: "2023-07-06T12:34:56Z",
                newestCommentTime: "2023-07-06T12:34:56Z",
                featuredCommunity: false,
                featuredLocal: false,
                hotRank: 1,
                hotRankActive: 1
            ),
            subscribed: .notSubscribed,
            saved: false,
            read: false,
            creatorBlocked: false,
            unreadComments: 3
        )
        
        PostRowView(post: post)
    }
}

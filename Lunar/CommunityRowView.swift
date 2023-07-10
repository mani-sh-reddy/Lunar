//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct CommunityRowView: View {
    var community: CommunitiesElement

    var body: some View {
        HStack {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))
            KFImage(URL(string: community.community.icon ?? ""))
                .setProcessor(processor)
                .placeholder { Image(systemName: "books.vertical.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.gray)
                }
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(community.community.title)
                .padding(.horizontal, 10)
        }

//        HStack {
//            KFImage(URL(string: community.community.icon ?? ""))
//                .placeholder { Image(systemName: "books.vertical.circle.fill")
//                    .font(.title)
//                    .symbolRenderingMode(.hierarchical)
//                    .foregroundColor(.gray)
//                }
//                .resizable()
//                .frame(width: 30, height: 30)
//                .clipShape(Circle())
//            Spacer().frame(width: 15)
//            Text(community.community.title)
//            Spacer()
//            Spacer().frame(width: 5)
//        }
    }
}

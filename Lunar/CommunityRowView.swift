//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI
import Kingfisher

struct CommunityRowView: View {
    var community: CommunitiesElement
    
    
    var body: some View {
        HStack {
            KFImage(URL(string: community.community.icon ?? ""))
                .placeholder { Image(systemName: "books.vertical.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                }
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Spacer().frame(width: 15)
            Text(community.community.title)
            Spacer()
            //            Group {
            //                Text("\(community.counts.subscribers)")
            //                Image(systemName: "person.2")
            //            }
            //            .font(.footnote)
            //            .opacity(0.7)
            Spacer().frame(width: 5)
        }
    }
}

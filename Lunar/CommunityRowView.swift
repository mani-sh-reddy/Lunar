//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct CommunityRowView: View {
    var community: CommunityObject
    var counts: CountsObject
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: community.icon ?? "file:./LemmyLogo.png")) { image in
                image
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } placeholder: {
                Image("LemmyLogo", bundle: Bundle(identifier:"io.github.mani-sh-reddy.Lunar"))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            Spacer().frame(width: 15)
                Text(community.title)
                Spacer()
                Text("\(counts.subscribers)")
                    .font(.footnote)
                    .opacity(0.7)
            
        }
    }
}

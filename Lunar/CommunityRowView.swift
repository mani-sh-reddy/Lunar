//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct CommunityRow: View {
    var community: CommunityObject
    var counts: CountsObject
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: community.icon ?? "file:./LemmyLogo.png")) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Image("LemmyLogo", bundle: Bundle(identifier:"io.github.mani-sh-reddy.Lunar"))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            Spacer().frame(width: 10)
            VStack(alignment: .leading, content: {
                Text(community.title)
                Text("Subscribers: \(counts.subscribers)")
                    .font(.footnote)
                    .opacity(0.7)
            })
            Spacer()
            
        }
    }
}

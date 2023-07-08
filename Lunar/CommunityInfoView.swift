//
//  PostView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct CommunityInfoView: View {
    var community: CommunityObject

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    KFImage(URL(string: community.icon ?? ""))
                        .placeholder { Image("LunarLogo") }
                        .resizable()
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .padding()
                        .aspectRatio(contentMode: .fit)
                    HStack {
                        Text(community.description ?? "No Description")
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
                .frame(alignment: .top)
                .navigationTitle(community.title)
            }
        }
    }
}

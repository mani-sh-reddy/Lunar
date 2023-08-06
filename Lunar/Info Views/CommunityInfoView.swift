//
//  CommunityInfoView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct CommunityInfoView: View {
    var community: SearchCommunityInfo
    var hasBanner: Bool {
        community.banner != "" && community.banner != nil
    }

    var hasAvatar: Bool {
        community.icon != "" && community.icon != nil
    }

    var body: some View {
        ScrollView {
            if hasBanner {
                ZStack {
                    KFImage(URL(string: community.banner ?? ""))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(width: .infinity)
                        .padding()
                }
                .padding(.bottom, 50)
            }

            VStack(alignment: .leading) {
                HStack {
                    if hasAvatar {
                        KFImage(URL(string: community.icon ?? ""))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(maxWidth: 50, maxHeight: 50)
                            .padding(5)
                    }
                    VStack(alignment: .leading) {
                        Text(community.name)
                            .font(.title).bold()
                        Text("@\(URLParser.extractDomain(from: community.actorID))").font(.headline)
                    }
                }.padding(.bottom, 10)

                if let description = community.description {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundStyle(.ultraThinMaterial)
                        Text(description)
                            .padding(10)
                    }
                }
            }.padding()
        }
    }
}

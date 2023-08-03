//
//  InPostCommunityHeaderView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

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

//
//  CommentIndentGuideView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

struct CommentIndentGuideView: View {
    var commentPath: String

    var body: some View {
        let commentIndentLevel = commentPath.split(separator: ".").count - 1
        let commentIndentRange = 0 ..< commentIndentLevel

        ForEach(commentIndentRange, id: \.self) { _ in
            Capsule()
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 2)
        }
        .padding(.vertical, 10)
        .padding(.top, 5)
        .frame(alignment: .top)
    }
}

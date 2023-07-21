//
//  InPostThumbnailView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI
import Kingfisher

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

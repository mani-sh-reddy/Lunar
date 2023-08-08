//
//  InPostThumbnailImageView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import Kingfisher
import Nuke
import NukeUI
import SwiftUI
import UIKit

struct InPostThumbnailImageView: View {
//    @State private var isLoading = true
//    var loadImageOnlyFromCache: Bool
    var thumbnailURL: String
    var body: some View {
        KFImage(URL(string: thumbnailURL))
//            .onProgress { receivedSize, totalSize in
//                if receivedSize < totalSize {
//                    isLoading = true
//                } else {
//                    isLoading = false
//                }
//            }
            .resizable()
//            .cancelOnDisappear(true)
            .fade(duration: 0.2)
            .progressViewStyle(.circular)
            .aspectRatio(contentMode: .fit)
//            .frame(alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//            .padding(.bottom, 3)
    }
}

//
//  ImageViewWithPlaceholder.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct ImageViewWithPlaceholder: View {
    var imageURL: String?
    var placeholderSystemName: String

    var body: some View {
        let processor = DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
        if let url = imageURL, let image = URL(string: url) {
            KFImage(image)
                .setProcessor(processor)
                .placeholder {
                    Image(systemName: placeholderSystemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.gray)
                }
                .resizable()
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                .scaledToFit()
                .padding(.trailing, 5)
        } else {
            Image(systemName: placeholderSystemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.gray)
                .padding(.trailing, 5)
        }
    }
}

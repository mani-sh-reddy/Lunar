//
//  ImagePopoverView.swift
//  Lunar
//
//  Created by Mani on 26/07/2023.
//

import Foundation
import Kingfisher
import Nuke
import NukeUI
import SwiftUI
import UIKit

struct ImagePopoverView: View {
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

    @State private var isLoading = true
    @State private var imageSize: CGSize = .zero
    @Binding var showingPopover: Bool
    @State var buttonOpacity = 0.8

    private let pipeline = ImagePipeline {
        $0.dataLoader = {
            let config = URLSessionConfiguration.default
            return DataLoader(configuration: config)
        }()
    }

    let processor = DownsamplingImageProcessor(size: CGSize(width: 1_300, height: 1_300))
    var thumbnailURL: String

    var body: some View {
        ZStack {
            Rectangle().foregroundStyle(.black)
                .ignoresSafeArea()
            AsyncImage(url: URL(string: thumbnailURL)) { state in
                if let image = state.image {
                    PhotoDetailView(image: image.asUIImage())
                } else {
                    ProgressView()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//
//  ImagePopoverView.swift
//  Lunar
//
//  Created by Mani on 26/07/2023.
//

import Foundation
import Kingfisher
import SwiftUI
import UIKit

struct ImagePopoverView: View {
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

    @State private var isLoading = true
    @State private var imageSize: CGSize = .zero
    @Binding var showingPopover: Bool
    @State var buttonOpacity = 0.8

    let processor = DownsamplingImageProcessor(size: CGSize(width: 1300, height: 1300))
    var thumbnailURL: String

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle().foregroundStyle(.black).ignoresSafeArea()
            GeometryReader { proxy in
                KFImage(URL(string: thumbnailURL))
                    .onProgress { receivedSize, totalSize in
                        if receivedSize < totalSize {
                            isLoading = true
                        } else {
                            isLoading = false
                        }
                    }
                    .onSuccess { image in
                        print(image.image.size.width)
                        print(image.image.size.height)
                        print("proxy width: \(proxy.size.width)")
                        print("proxy height: \(proxy.size.height)")
                        DispatchQueue.main.async {
                            imageSize = CGSize(width: image.image.size.width, height: image.image.size.height)
                        }
                    }
                    .onlyFromCache()
                    .setProcessor(processor)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .padding(.all, 10)
                    .modifier(ImageModifier(contentSize: imageSize, showingPopover: $showingPopover))
            }
            Button {
                showingPopover = false
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous).opacity(0.1).foregroundStyle(.black.opacity(0.1)).frame(height: 100).opacity(0.1).border(debugModeEnabled ? .purple : .clear)
                    Text("Swipe here to dismiss").foregroundStyle(.gray).opacity(debugModeEnabled ? 1 : buttonOpacity)
                        .border(debugModeEnabled ? .red : .clear)
                }
            }.task {
                let animation = Animation.easeIn(duration: 3)
                withAnimation(animation) {
                    buttonOpacity = 0.2
                }
            }
        }
    }
}

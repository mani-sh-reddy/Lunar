//
//  SettingsClearCacheButtonView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Kingfisher
import SwiftUI
import UIKit

struct SettingsClearCacheButtonView: View {
    @State var cacheSize: String = ""
    let haptic = UINotificationFeedbackGenerator()

    @State var cacheClearButtonClicked: Bool = false
    @State var cacheClearButtonOpacity: Double = 1

    var body: some View {
        Button(action: {
            haptic.notificationOccurred(.success)
            clearCache()
            cacheClearButtonClicked = true
        }
        ) {
            Label {
                Text("Clear Cache")
                    .foregroundStyle(.red)
                Spacer()
                ZStack(alignment: .trailing) {
                    if !cacheClearButtonClicked {
                        Text(cacheSize)
                            .foregroundStyle(.red)
                    } else {
                        Group {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2).opacity(cacheClearButtonOpacity)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.red)
                        }.onAppear {
                            let animation = Animation.easeIn(duration: 2)
                            withAnimation(animation) {
                                cacheClearButtonOpacity = 0.1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                cacheClearButtonClicked = false
                                cacheClearButtonOpacity = 1
                            }
                        }
                    }
                }

            } icon: {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .task {
            calculateCache()
        }
    }

    func clearCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Cache clear button clicked") }
        calculateCache()
    }

    func calculateCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                cacheSize = "\(String(format: "%.0f", Double(size) / 1024 / 1024)) MB"
            case let .failure(error):
                print("calculateCache FUNCTION ERROR: \(error)")
            }
        }
    }
}

struct SettingsClearCacheButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsClearCacheButtonView()
    }
}

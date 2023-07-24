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

    var body: some View {
        Button(action: {
            clearCache()
            haptic.notificationOccurred(.success)
        }
        ) {
            Label {
                Text("Clear Cache")
                Spacer()
                Text(cacheSize)

            } icon: {
                Image(systemName: "trash.fill")
                    .symbolRenderingMode(.hierarchical)
            }.foregroundStyle(.red)
        }
        .task {
            calculateCache()
        }
    }

    func clearCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Done") }
        calculateCache()
    }

    func calculateCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                cacheSize = "\(String(format: "%.0f", Double(size) / 1024 / 1024)) MB"
            case let .failure(error):
                print(error)
            }
        }
    }
}

struct SettingsClearCacheButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsClearCacheButtonView()
    }
}

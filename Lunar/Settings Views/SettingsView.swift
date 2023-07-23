//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import Kingfisher
import SwiftUI

struct SettingsView: View {
//    @Binding var lemmyInstance: String
    @State var cacheSize: String = ""
    @AppStorage("instanceHostURL") var instanceHostURL = DefaultSettings.instanceURL

    var body: some View {
        VStack(spacing: 30) {
            Text(instanceHostURL)
            TextField("Enter username...", text: $instanceHostURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Disk cache size: \(cacheSize)")
            Button("clear cache") {
                clearCache()
            }
        }.task {
            calculateCache()
        }
    }

    func clearCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Done") }
    }

    func calculateCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                cacheSize = "\(Double(size) / 1024 / 1024) MB"
            case let .failure(error):
                print(error)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import Kingfisher
import SwiftUI

struct SettingsView: View {
    @Binding var lemmyInstance: String
    
    var body: some View {
        VStack {
            Text(lemmyInstance)
            TextField("Enter username...", text: $lemmyInstance)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }.onAppear {
            func cacheSize() {
                ImageCache.default.calculateDiskStorageSize { result in
                    switch result {
                    case .success(let size):
                        print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(lemmyInstance: .constant("lemmy.world"))
    }
}

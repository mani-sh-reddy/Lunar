//
//  SettingsClearCacheButtonView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Kingfisher
import Nuke
import SwiftUI
import UIKit

struct SettingsClearCacheButtonView: View {
  @State var cacheSize: String = ""
  let haptic = UINotificationFeedbackGenerator()

  @State var cacheClearButtonClicked: Bool = false
  @State var cacheClearButtonOpacity: Double = 1

  @State private var diskCacheUsage: String = ""

  var body: some View {
    Button {
      haptic.notificationOccurred(.success)
      clearCache()
      cacheClearButtonClicked = true
    } label: {
      Label {
        Text("Clear Cache")
          .foregroundStyle(.red)
        Spacer()
        ZStack(alignment: .trailing) {
          if !cacheClearButtonClicked {
            //              Text(humanReadableByteCount(bytes: URLCache.shared.diskCapacity))
            //              .foregroundStyle(.red)
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
  }

  func humanReadableByteCount(bytes: Int) -> String {
    if bytes < 1000 { return "\(bytes) B" }
    let exp = Int(log2(Double(bytes)) / log2(1000.0))
    let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
    let number = Double(bytes) / pow(1000, Double(exp))
    if exp <= 1 || number >= 100 {
      return String(format: "%.0f %@", number, unit)
    } else {
      return String(format: "%.1f %@", number, unit)
        .replacingOccurrences(of: ".0", with: "")
    }
  }

  func clearCache() {
    let cache = ImageCache.default
    cache.clearMemoryCache()
    cache.clearDiskCache { print("Cache clear button clicked") }
    //    calculateCache()
  }
}

struct SettingsClearCacheButtonView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsClearCacheButtonView()
      .previewLayout(.sizeThatFits)
  }
}

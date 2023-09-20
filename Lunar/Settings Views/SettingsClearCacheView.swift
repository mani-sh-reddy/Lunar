//
//  SettingsClearCacheView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Defaults
import Nuke
import SFSafeSymbols
import SwiftUI
import UIKit

enum CacheInfoType {
  case total
  case limit
}

struct SettingsClearCacheView: View {
  @Default(.appBundleID) var appBundleID

  @EnvironmentObject var dataCacheHolder: DataCacheHolder

  @State var alertPresented: Bool = false
  @State var cacheClearButtonOpacity: Double = 1
  @State var cacheTotal: String = "0 B"

  let haptics = UINotificationFeedbackGenerator()

  var body: some View {
    Label {
      Text("Total Size: \(cacheTotal)")
    } icon: {
      Image(systemSymbol: .externaldrive)
        .symbolRenderingMode(.multicolor)
        .foregroundStyle(.gray)
    }
    .onAppear {
      cacheTotal = cacheInfo(cacheInfoType: .total)
    }
    Label {
      Text("Limit: \(cacheInfo(cacheInfoType: .limit))")
    } icon: {
      Image(systemSymbol: .externaldriveFill)
        .symbolRenderingMode(.multicolor)
        .foregroundStyle(.gray)
    }
    Button {
      alertPresented = true
    } label: {
      Label {
        Text("Clear Cache")
          .foregroundStyle(.foreground)
        Spacer()
          .foregroundStyle(.red)
      } icon: {
        Image(systemSymbol: .externaldriveFillBadgeXmark)
          .foregroundStyle(.gray)
          .symbolRenderingMode(.multicolor)
      }
    }
    .alert("Clear Cache", isPresented: $alertPresented) {
      Button("Clear", role: .destructive) {
        if let dataCache = dataCacheHolder.dataCache {
          dataCache.removeAll()
          haptics.notificationOccurred(.success)
//          let cacheTotal = cacheInfo(cacheInfoType: .total)
          cacheTotal = "0 B"
          alertPresented = false
        }
      }
    }
  }

  func cacheInfo(cacheInfoType: CacheInfoType) -> String {
    if let dataCache = dataCacheHolder.dataCache {
      if cacheInfoType == .total {
        humanReadableByteCount(bytes: dataCache.totalSize)
      } else {
        humanReadableByteCount(bytes: dataCache.sizeLimit)
      }
    } else {
      ""
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
}

struct SettingsClearCacheView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsClearCacheView()
      .previewLayout(.sizeThatFits)
  }
}

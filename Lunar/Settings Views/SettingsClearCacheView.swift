//
//  SettingsClearCacheButtonView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Nuke
import SwiftUI
import UIKit
import SFSafeSymbols

enum CacheInfoType {
  case total
  case limit
}

struct SettingsClearCacheView: View {
  @EnvironmentObject var dataCacheHolder: DataCacheHolder
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  
  @State var alertPresented: Bool = false
  @State var cacheClearButtonOpacity: Double = 1
  
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    Label {
      Text("Total Size: \(cacheInfo(cacheInfoType: .total))")
    } icon: {
      Image(systemSymbol: .externaldrive)
        .symbolRenderingMode(.multicolor)
        .foregroundStyle(.gray)
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
          let _ = cacheInfo(cacheInfoType: .total)
          alertPresented = false
        }
      }
    }
  }
  
  func cacheInfo(cacheInfoType: CacheInfoType) -> String {
    if let dataCache = dataCacheHolder.dataCache {
      if cacheInfoType == .total {
        return humanReadableByteCount(bytes: dataCache.totalSize)
      } else {
        return humanReadableByteCount(bytes: dataCache.sizeLimit)
      }
    } else {
      return ""
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

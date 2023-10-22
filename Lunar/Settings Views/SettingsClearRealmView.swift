//
//  SettingsClearRealmView.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Defaults
import Nuke
import RealmSwift
import SFSafeSymbols
import SwiftUI
import UIKit

struct SettingsClearRealmView: View {
  @Default(.appBundleID) var appBundleID
  @EnvironmentObject var dataCacheHolder: DataCacheHolder

  @State var alertPresented: Bool = false
  @State var cacheTotal: String = "0 B"
  let haptics = UINotificationFeedbackGenerator()

  var body: some View {
    Label {
      Text("Database Storage Used: \(cacheTotal)")
    } icon: {
      Image(systemSymbol: .squareStack3dUpFill)
        .foregroundStyle(.gray)
        .symbolRenderingMode(.hierarchical)
    }
    Button {
      alertPresented = true
    } label: {
      Label {
        Text("Reset Database")
          .foregroundStyle(.foreground)
      } icon: {
        Image(systemSymbol: .squareStack3dUpSlash)
          .foregroundStyle(.red, .gray)
          .symbolRenderingMode(.palette)
      }
    }
    .alert("Reset Database", isPresented: $alertPresented) {
      Button("Reset", role: .destructive) {
        clearCache()
      }
    }
    .onAppear {
      calculateCache()
    }
  }

  func calculateCache() {
    DispatchQueue.global(qos: .background).async {
      if let realmPath = Realm.Configuration.defaultConfiguration.fileURL?.relativePath {
        do {
          let attributes = try FileManager.default.attributesOfItem(atPath: realmPath)
          if let fileSize = attributes[FileAttributeKey.size] as? Double {
            let databaseSize = humanReadableByteCount(bytes: fileSize)
            DispatchQueue.main.async {
              cacheTotal = databaseSize
            }
          }
        } catch {
          print("?")
        }
      }
    }
  }

  func clearCache() {
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
    cacheTotal = "0 B"
    calculateCache()
    haptics.notificationOccurred(.success)
  }

  func humanReadableByteCount(bytes: Double) -> String {
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

// struct SettingsClearCacheView_Previews: PreviewProvider {
//  static var previews: some View {
//    SettingsClearCacheView()
//      .previewLayout(.sizeThatFits)
//  }
// }

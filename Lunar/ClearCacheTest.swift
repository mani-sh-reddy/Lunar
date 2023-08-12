//
//  ContentView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

struct SettingsView: View {
  @Binding var lemmyInstance: String

  var body: some View {
    VStack {
      Button(action: {
        KingfisherManager.shared.cache.clearCache()
        let cache = URLCache()
        cache.removeAllCachedResponses()
      }) {
        HStack {
          Image(systemName: "trash.circle.fill")
            .font(.title)
          Text("Clear Cache")
            .fontWeight(.semibold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(Color.red)
        .cornerRadius(50)
      }
      TextField(
        "instance",
        text: $lemmyInstance
      ).textFieldStyle(.roundedBorder)
    }
  }
}

// struct ClearCacheTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ClearCacheTest()
//    }
// }

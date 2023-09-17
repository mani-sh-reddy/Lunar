//
//  SettingsFeedView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SwiftUI

struct SettingsFeedView: View {
  var body: some View {
    List {
      // MARK: - Posts Section

      Section {} header: {
        Text("Feed Options")
      }
    }
    .navigationTitle("Feed Options")
  }
}

struct SettingsFeedView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsFeedView()
  }
}

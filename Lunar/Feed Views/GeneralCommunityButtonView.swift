//
//  GeneralCommunityButtonView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SwiftUI

struct GeneralCommunityButtonView: View {
  var quicklink: Quicklink
  
  let colorConverter = ColorConverter()
  
  var body: some View {
    HStack {
      Image(systemName: quicklink.icon)
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(colorConverter.convertStringToColor(quicklink.iconColor))
      Text(quicklink.title)
        .padding(.horizontal, 10)
    }
  }
}

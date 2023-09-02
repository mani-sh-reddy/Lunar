//
//  ImageExtension.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

extension Image {
  init(asset name: String) {
    self.init(uiImage: UIImage(named: name)!) // skipcq: SW-W1023
  }
}

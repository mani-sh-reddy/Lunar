//
//  PhotoDetailView.swift
//  Lunar
//
//  Created by Mani on 02/08/2023.
//

import Foundation
import PDFKit
import SwiftUI
import UIKit

struct PhotoDetailView: UIViewRepresentable {
  let image: UIImage

  func makeUIView(context _: Context) -> PDFView {
    let view = PDFView()
    view.sizeToFit()
    view.document = PDFDocument()

    guard let page = PDFPage(image: image) else { return view }
    view.document?.insert(page, at: 0)
    view.autoScales = true
    view.backgroundColor = UIColor.black
    view.displayMode = .singlePageContinuous
    view.displayDirection = .vertical
    
    return view
  }

  func updateUIView(_: PDFView, context _: Context) {

  }
}

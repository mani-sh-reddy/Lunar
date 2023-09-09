//
//  ColorConverter.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SwiftUI

class ColorConverter {
  public func convertStringToColor(_ colorString: String) -> Color {
    switch colorString {
    case "black" :
      return Color.black
    case "blue" :
      return Color.blue
    case "brown" :
      return Color.brown
    case "cyan" :
      return Color.cyan
    case "gray" :
      return Color.gray
    case "green" :
      return Color.green
    case "indigo" :
      return Color.indigo
    case "mint" :
      return Color.mint
    case "orange" :
      return Color.orange
    case "pink" :
      return Color.pink
    case "purple" :
      return Color.purple
    case "red" :
      return Color.red
    case "teal" :
      return Color.teal
    case "white" :
      return Color.white
    case "yellow" :
      return Color.yellow
    default:
      return Color.clear
    }
  }
}

import UIKit
import SwiftUI

//let systemColor = Color.red
//let color = Color(red: 0.3, green: 0.5, blue: 1)

extension Color {
  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    let length = hexSanitized.count
    
    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
    
    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
      
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x000000FF) / 255.0
      
    } else {
      return nil
    }
    
    self.init(red: r, green: g, blue: b, opacity: a)
  }
}

import UIKit

extension Color {
  func toHex() -> String? {
    let uic = UIColor(self)
    guard let components = uic.cgColor.components, components.count >= 3 else {
      return nil
    }
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    var a = Float(1.0)
    
    if components.count >= 4 {
      a = Float(components[3])
    }
    
    if a != Float(1.0) {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }
}

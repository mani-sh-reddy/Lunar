//
//  ImageDownloadManager.swift
//  Lunar
//
//  Created by Mani on 11/11/2023.
//

import Foundation
import SwiftUI
import UIKit

class ImageDownloadManager {
  private let suiteName: String

  init(suiteName: String) {
    self.suiteName = suiteName
  }

  func storeImage(fromURL imageURL: URL, forKey key: String, completion: @escaping (Bool) -> Void) {
    // Download image from the remote URL
    downloadImage(from: imageURL) { image in
      guard let image else {
        completion(false)
        return
      }

      // Store the downloaded image
      self.store(image: image, forKey: key, completion: completion)
    }
  }

  private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error {
        print("Error downloading image: \(error)")
        completion(nil)
        return
      }

      if let data, let image = UIImage(data: data) {
        completion(image)
      } else {
        completion(nil)
      }
    }.resume()
  }

  private func store(image: UIImage, forKey key: String, completion: @escaping (Bool) -> Void) {
    if let pngRepresentation = image.pngData() {
      let fileManager = FileManager.default
      if let documentsURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: suiteName) {
        let fileURL = documentsURL.appendingPathComponent("\(key).png")
        do {
          try pngRepresentation.write(to: fileURL)
          UserDefaults(suiteName: suiteName)?.set(fileURL.path, forKey: key)
          completion(true)
        } catch {
          print("Error writing image to file: \(error)")
          completion(false)
        }
      } else {
        completion(false)
      }
    } else {
      completion(false)
    }
  }

  func loadImage(forKey key: String, completion: @escaping (UIImage?) -> Void) {
    if let filePath = UserDefaults(suiteName: suiteName)?.string(forKey: key) {
      let fileURL = URL(fileURLWithPath: filePath)
      do {
        let imageData = try Data(contentsOf: fileURL)
        let image = UIImage(data: imageData)
        completion(image)
      } catch {
        print("Error loading image from file: \(error)")
        completion(nil)
      }
    } else {
      completion(nil)
    }
  }

  func deleteImage(forKey key: String, completion: @escaping (Bool) -> Void) {
    if let filePath = UserDefaults(suiteName: suiteName)?.string(forKey: key) {
      let fileURL = URL(fileURLWithPath: filePath)
      do {
        try FileManager.default.removeItem(at: fileURL)
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
        completion(true)
      } catch {
        print("Error deleting image: \(error)")
        completion(false)
      }
    } else {
      completion(false)
    }
  }
}

// private func store(image: UIImage, forKey key: String) {
//  if let pngRepresentation = image.pngData() {
//    let fileManager = FileManager.default
//    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//      let fileURL = documentsURL.appendingPathComponent("\(key).png")
//      do {
//        try pngRepresentation.write(to: fileURL)
//      } catch {
//        print("Error writing image to file: \(error)")
//      }
//    }
//  }
// }

//
//  ImageSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class ImageSender: ObservableObject {
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.selectedActorID) var selectedActorID
  @Default(.appBundleID) var appBundleID

  private var jwt: String = ""
  private var imageData: Data // Change this to Data

  let pulse = Pulse.LoggerStore.shared

  init(
    image: UIImage?
  ) {
    imageData = image?.pngData() ?? Data() // Convert UIImage to Data
    jwt = getJWTFromKeychain(actorID: selectedActorID) ?? ""
  }

  fileprivate func multipartProcessor(_ multipartFormData: MultipartFormData) {
    let parameters = [
      "auth": jwt,
    ] as [String: Any]

    for (key, value) in parameters {
      if let temp = value as? String {
        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
      }
      if let temp = value as? Int {
        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
      }
      if let temp = value as? NSArray {
        temp.forEach { element in
          let keyObj = key + "[]"
          if let string = element as? String {
            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
          } else if let num = element as? Int {
            let value = "\(num)"
            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
          }
        }
      }
    }
  }

  func uploadImage(completion: @escaping (String, String?, String?) -> Void) {
    let endpoint = "https://\(URLParser.extractDomain(from: selectedActorID))/api/v3/pictrs/image"
    let headers: HTTPHeaders = [
      "Accept": "application/json", // Removed Content-type
    ]

    AF.upload(
      multipartFormData: { multipartFormData in
        self.multipartProcessor(multipartFormData)
        if !self.imageData.isEmpty { // Check if imageData is not empty
          multipartFormData.append(
            self.imageData,
            withName: "file",
            fileName: "\(Date().timeIntervalSince1970).png",
            mimeType: "image/png"
          )
        }
      },
      to: endpoint,
      method: .post,
      headers: headers
    )
    .responseDecodable(of: ImageUploadResponseModel.self) { response in
      switch response.result {
      case let .success(result):

        completion(result.msg, String(result.files[0].file), result.files[0].deleteToken)

      case let .failure(error):
        if let data = response.data,
           let _ = try? JSONDecoder().decode(ImageUploadResponseModel.self, from: data)
        {
          completion(String(error.responseCode ?? 0), "UPLOAD_ERROR", "UPLOAD_ERROR")

        } else {
          // Handle JSON decoding errors
          print(
            "ImageSender JSON DECODE ERROR: \(error): \(String(describing: error.errorDescription))"
          )
          completion(String(error.responseCode ?? 0), "JSON_DECODE_ERROR", "JSON_DECODE_ERROR")
        }
      }
    }
  }

  func getJWTFromKeychain(actorID: String) -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

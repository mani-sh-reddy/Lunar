//
//  ReportPostSender.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class ReportPostSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID

  private var postID: Int
  private var reportReason: String

  init(
    postID: Int,
    reportReason: String
  ) {
    self.postID = postID
    self.reportReason = reportReason
  }

  func sendReport(completion: @escaping (Int?, Int?, Bool) -> Void) {
    let JSONparameters =
      [
        "post_id": postID,
        "reason": reportReason,
        "auth": JWT().getJWTForActiveAccount() as Any,
      ] as [String: Any]

    let endpoint = "https://\(activeAccount.instance)/api/v3/post/report"

    AF.request(
      endpoint,
      method: .post,
      parameters: JSONparameters,
      encoding: JSONEncoding.default,
      headers: GenerateHeaders().generate()
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: ReportPostResponseModel.self) { response in

      PulseWriter().write(response, EndpointParameters(endpointPath: endpoint), .post)

      print(response.request ?? "")
      switch response.result {
      case let .success(result):
        let postID = result.postReportView.post.id
        let postReportID = result.postReportView.postReport.id
        let response = String(response.response?.statusCode ?? 0)

        completion(postID, postReportID, true)

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("BlockUserSender ERROR: \(fetchError.error)")
          completion(nil, nil, false)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("BlockUserSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(nil, nil, false)
        }
      }
    }
  }
}

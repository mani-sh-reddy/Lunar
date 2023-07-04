//
//  ReportSender.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Alamofire
import Defaults
import SwiftUI

enum ReportObjectType {
  case post
  case comment
  case message
}

class ReportSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID

  private var postID: Int?
  private var commentID: Int?
  private var privateMessageID: Int?
  private var reportObjectType: ReportObjectType
  private var reportReason: String

  init(
    postID: Int? = 0,
    commentID: Int? = 0,
    privateMessageID: Int? = 0,
    reportObjectType: ReportObjectType,
    reportReason: String
  ) {
    self.postID = postID
    self.commentID = commentID
    self.privateMessageID = privateMessageID
    self.reportObjectType = reportObjectType
    self.reportReason = reportReason
  }

  func sendReport(completion: @escaping (Int?, Int?, Bool) -> Void) {
    var JSONparameters =
      [
        "reason": reportReason,
        "auth": JWT().getJWTForActiveAccount() as Any,
      ] as [String: Any]

    var endpoint = ""

    switch reportObjectType {
    case .post:
      JSONparameters["post_id"] = postID
      endpoint = "https://\(activeAccount.instance)/api/v3/post/report"
    case .comment:
      JSONparameters["comment_id"] = commentID
      endpoint = "https://\(activeAccount.instance)/api/v3/comment/report"
    case .message:
      JSONparameters["private_message_id"] = privateMessageID
      endpoint = "https://\(activeAccount.instance)/api/v3/private_message/report"
    }

    AF.request(
      endpoint,
      method: .post,
      parameters: JSONparameters,
      encoding: JSONEncoding.default,
      headers: GenerateHeaders().generate()
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: ReportResponseModel.self) { response in

      PulseWriter().write(response, EndpointParameters(endpointPath: endpoint), .post)

      print(response.request ?? "")
      switch response.result {
      case let .success(result):

        var itemID: Int = 0
        var reportID: Int = 0

        switch self.reportObjectType {
        case .post:
          itemID = result.postReportModel?.post.id ?? 0
          reportID = result.postReportModel?.postReport.id ?? 0
        case .comment:
          itemID = result.commentReportModel?.comment.id ?? 0
          reportID = result.commentReportModel?.commentReport.commentID ?? 0
        case .message:
          itemID = result.privateMessageReportModel?.privateMessage.id ?? 0
          reportID = result.privateMessageReportModel?.privateMessageReport.privateMessageID ?? 0
        }

        let _ = String(response.response?.statusCode ?? 0)

        completion(itemID, reportID, true)

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("BlockUserSender ERROR: \(fetchError.error)")
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("BlockUserSender JSON DECODE ERROR: \(error): \(errorDescription)")
        }
        completion(nil, nil, false)
      }
    }
  }
}

//
//  BlockUserSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class BlockUserSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID

  private var personID: Int
  private var block: Bool

  init(
    personID: Int,
    block: Bool
  ) {
    self.personID = personID
    self.block = block
  }

  func blockUser(completion: @escaping (Int?, Bool?, String?) -> Void) {
    let JSONparameters =
      [
        "block": block,
        "person_id": personID,
        "auth": JWT().getJWTForActiveAccount() as Any,
      ] as [String: Any]

    let endpoint = "https://\(activeAccount.instance)/api/v3/user/block"

    AF.request(
      endpoint,
      method: .post,
      parameters: JSONparameters,
      encoding: JSONEncoding.default,
      headers: GenerateHeaders().generate()
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: BlockUserResponseModel.self) { response in

      PulseWriter().write(response, EndpointParameters(endpointPath: endpoint), .post)

      print(response.request ?? "")
      switch response.result {
      case let .success(result):
        print(result.blocked)
        let response = String(response.response?.statusCode ?? 0)
        let userIsBlockedResponse = result.blocked
        let personID = result.person?.person.id

        completion(personID, userIsBlockedResponse, response)

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("BlockUserSender ERROR: \(fetchError.error)")
          completion(nil, nil, fetchError.error)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("BlockUserSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(nil, nil, error.errorDescription)
        }
      }
    }
  }
}

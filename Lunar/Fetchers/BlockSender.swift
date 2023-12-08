//
//  BlockSender.swift
//  Lunar
//
//  Created by Mani on 07/12/2023.
//

import Alamofire
import Defaults
import SwiftUI

enum BlockableObjectType {
  case person
  case community
}

class BlockSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID

  private var personID: Int?
  private var communityID: Int?
  private var blockableObjectType: BlockableObjectType
  private var block: Bool

  init(
    personID: Int? = 0,
    communityID: Int? = 0,
    blockableObjectType: BlockableObjectType,
    block: Bool
  ) {
    self.personID = personID
    self.communityID = communityID
    self.blockableObjectType = blockableObjectType
    self.block = block
  }

  func blockUser(completion: @escaping (Int?, Bool?, Bool?) -> Void) {
    var JSONparameters =
      [
        "block": block,
        "auth": JWT().getJWTForActiveAccount() as Any,
      ] as [String: Any]

    var endpoint = ""

    switch blockableObjectType {
    case .person:
      JSONparameters["person_id"] = personID
      endpoint = "https://\(activeAccount.instance)/api/v3/user/block"
    case .community:
      JSONparameters["community_id"] = communityID
      endpoint = "https://\(activeAccount.instance)/api/v3/community/block"
    }

    AF.request(
      endpoint,
      method: .post,
      parameters: JSONparameters,
      encoding: JSONEncoding.default,
      headers: GenerateHeaders().generate()
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: BlockResponseModel.self) { response in

      PulseWriter().write(response, EndpointParameters(endpointPath: endpoint), .post)

      print(response.request ?? "")
      switch response.result {
      case let .success(result):
        print(result.blocked)

        var itemID: Int = 0

        switch self.blockableObjectType {
        case .person:
          itemID = result.person?.person.id ?? 0
        case .community:
          itemID = result.community?.community.id ?? 0
        }

        let isBlockedResponse = result.blocked

        completion(itemID, isBlockedResponse, true)

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

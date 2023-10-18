//
//  JSONDecoderExtension.swift
//  Lunar
//
//  Created by Mani on 18/10/2023.
//

// import Foundation
// import Alamofire
//
// extension JSONDecoder {
//  func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> T? {
//    guard response.error == nil, let responseData = response.data else {
//      return nil
//    }
//    do {
//      let item = try decode(T.self, from: responseData)
//      return item
//    } catch {
//      print(error)
//      return nil
//    }
//  }
// }

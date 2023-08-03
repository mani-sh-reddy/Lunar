//
//  LoggedInUserModel.swift
//  Lunar
//
//  Created by Mani on 31/07/2023.
//

import Foundation

struct LoggedInAccount: Codable, Hashable {
    var userID: String = ""
    var name: String = ""
    var email: String = ""
    var avatarURL: String = ""
    var actorID: String = ""
}

// extension LoggedInAccount: RawRepresentable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//            let result = try? JSONDecoder().decode(LoggedInAccount.self, from: data)
//        else {
//            return nil
//        }
//        self = result
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//            let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
// }

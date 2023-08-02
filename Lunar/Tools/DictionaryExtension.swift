//
//  DictionaryExtension.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import Foundation

extension [String: String]: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), // convert from String to Data
              let result = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "{}" // empty Dictionary resprenseted as String
        }
        return result
    }
}

//
//  UUIDToInt.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

func djb2Hash(_ input: String) -> UInt32 {
  var hash: UInt32 = 5381

  for char in input.utf8 {
    hash = ((hash << 5) &+ hash) &+ UInt32(char)
  }

  return hash
}

func UUIDToInt(uuid: UUID) -> Int {
  // Get the uuid's uuidString property
  let uuidString = uuid.uuidString

  // Use a hash function (e.g., DJB2) to generate a hash value
  let hashValue = djb2Hash(uuidString)

  // Convert the hash value to a 32-bit Int
  let intValue = Int(hashValue & 0xFFFF_FFFF)

  return intValue
}

//
//  UUIDToInt.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

// Function to convert UUID to Int
func UUIDToInt(uuid: UUID) -> Int {
  // Get the uuid's uuidString property
  let uuidString = uuid.uuidString

  // Use a hash function (e.g., DJB2) to generate a hash value
  let hashValue = djb2Hash(uuidString)

  // Convert the hash value to an Int
  let intValue = Int(hashValue)

  return intValue
}

// DJB2 Hash Function
func djb2Hash(_ input: String) -> UInt64 {
  var hash: UInt64 = 5381
  for byte in input.utf8 {
    hash = (hash &* 33) ^ UInt64(byte)
  }
  return hash
}

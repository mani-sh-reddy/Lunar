//
//  IdentifierGenerators.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Foundation
import SwiftUI

class IdentifierGenerators {
  func postIdentifier(
    instance: String,
    sortParameter: String?,
    typeParameter: String?,
    userUsed: String?,
    communityID: String?,
    personID: String?
  ) -> String {
    var identifier = ""

    identifier.append(String("INSTANCE:"))
    identifier.append(String(instance))
    identifier.append(String("_SORT:"))
    if let sortParameter { identifier.append(String(sortParameter)) }
    identifier.append(String("_TYPE:"))
    if let typeParameter { identifier.append(String(typeParameter)) }
    identifier.append(String("_USER:"))
    if let userUsed { identifier.append(String(userUsed)) }
    identifier.append(String("_COMMUNITY:"))
    if let communityID { identifier.append(String(communityID)) }
    identifier.append(String("_PERSON:"))
    if let personID { identifier.append(String(personID)) }

    return identifier
  }
}

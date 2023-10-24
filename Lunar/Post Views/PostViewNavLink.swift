//
//  PostViewNavLink.swift
//  Lunar
//
//  Created by Mani on 24/10/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

/// # RealmDataState Table
/// Checking if the realm data state object for the identifier (primary key) exists
/// the object will not exist on the first run
/// ## Identifier
/// The identifier (aka the primary key) is generated automatically when creating the RealmDataState object
/// It uses the other variables passed in to generate it such as instance..etc
/// here it is being filtered based on identifier - there can only be one, so using .first
/// Example identifier generated using **IdentifierGenerators.postIdentifier**
/// `"INSTANCE:lemmy.world_SORT:Active_TYPE:All_USER:_COMMUNITY:_PERSON:"`
/// ## New PostsFetcher
/// This is run if the object above is not found
/// It runs the postfetcher, which then creates a realmDataStateObject
/// subsequent runs will use the newly created realmDataStateObject
struct PostsViewLink: View {
  @ObservedResults(RealmDataState.self) var realmDataState
  @Default(.selectedInstance) var selectedInstance

  var sort: String
  var type: String
  var user: Int?
  var community: Int?
  var person: Int?

  @State var loopedOnce: Bool = false

  var body: some View {
    let fetcherIdentifier = generatePostIdentifier(
      sortParameter: sort,
      typeParameter: type,
      userUsed: user,
      communityID: community,
      personID: person
    )
    if let realmDataStateObject = realmDataState.where({
      $0.identifier == fetcherIdentifier
    }).first {
      PostsView(realmDataState: realmDataStateObject, sort: sort, type: type)
    } else {
      let _ = print("Object not found, fetching")
      let _ = print(loopedOnce)
      if !loopedOnce {
        let _ = PostsFetcher(
          sortParameter: sort,
          typeParameter: type,
          currentPage: 1
        )
        let _ = loopedOnce = true
      }
    }
  }

  func generatePostIdentifier(
    sortParameter: String?,
    typeParameter: String?,
    userUsed: Int?,
    communityID: Int?,
    personID: Int?
  ) -> String {
    var identifier = ""

    identifier.append(String("INSTANCE:"))
    identifier.append(String(selectedInstance))
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

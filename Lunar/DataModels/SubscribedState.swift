//
//  SubscribedState.swift
//  Lunar
//
//  Created by Mani on 01/09/2023.
//

import Foundation
import RealmSwift

enum SubscribedState: String, Codable, PersistableEnum {
  case notSubscribed = "NotSubscribed"
  case subscribed = "Subscribed"
  case pending = "Pending"
}

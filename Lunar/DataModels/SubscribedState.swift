//
//  SubscribedState.swift
//  Lunar
//
//  Created by Mani on 01/09/2023.
//

import Foundation

enum SubscribedState: String, Codable {
  case notSubscribed = "NotSubscribed"
  case subscribed = "Subscribed"
  case pending = "Pending"
}

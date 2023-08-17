//
//  VoteState.swift
//  Lunar
//
//  Created by Mani on 17/08/2023.
//

import Foundation

import SwiftUI

class VoteState: ObservableObject {
  @Published var upvoteStates: [Int: Bool] = [:]
  @Published var downvoteStates: [Int: Bool] = [:]
  
  func toggleUpvote(postID: Int) {
    upvoteStates[postID]?.toggle()
    downvoteStates[postID] = false
  }
  
  func toggleDownvote(postID: Int) {
    downvoteStates[postID]?.toggle()
    upvoteStates[postID] = false
  }
}

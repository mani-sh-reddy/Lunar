//
//  DroppableList.swift
//  Lunar
//
//  Created by Mani on 29/08/2023.
//

import SwiftUI

struct DroppableList: View {
  let title: String
  @Binding var users: [String]
  
  //this action is performed when a drop is made
  //parameters are:
  //  the dropped String
  //  the index where it was dropped
  //it's Optional in case we don't need to anything else
  let action: ((String, Int) -> Void)?
  
  init(_ title: String, users: Binding<[String]>, action: ((String, Int) -> Void)? = nil) {
    self.title = title
    self._users = users //assign to the Binding, nont the WrappedValue
    self.action = action
  }
  
  var body: some View {
    List {
      Text(title)
        .font(.subheadline)
      ForEach(users, id: \.self) { user in
        Text(user)
          .onDrag { NSItemProvider(object: user as NSString) }
      }
      .onMove(perform: moveUser)
      .onInsert(of: ["public.text"], perform: dropUser)
    }
  }
  
  func moveUser(from source: IndexSet, to destination: Int) {
    users.move(fromOffsets: source, toOffset: destination)
  }
  
  func dropUser(at index: Int, _ items: [NSItemProvider]) {
    for item in items {
      _ = item.loadObject(ofClass: String.self) { droppedString, _ in
        if let ss = droppedString, let dropAction = action {
          DispatchQueue.main.async {
            dropAction(ss, index)
          }
        }
      }
    }
  }
}

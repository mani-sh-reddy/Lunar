//
//  EditableList.swift
//  Lunar
//
//  Created by Mani on 29/08/2023.
//

import SwiftUI

struct EditableList<
  Data: RandomAccessCollection & MutableCollection & RangeReplaceableCollection,
  Content: View
>: View where Data.Element: Identifiable {
  @Binding var data: Data
  var content: (Binding<Data.Element>) -> Content

  init(
    _ data: Binding<Data>,
    content: @escaping (Binding<Data.Element>) -> Content
  ) {
    self._data = data
    self.content = content
  }

  var body: some View {
    List {
      ForEach($data, content: content)
        .onMove { indexSet, offset in
          data.move(fromOffsets: indexSet, toOffset: offset)
        }
        .onDelete { indexSet in
          data.remove(atOffsets: indexSet)
        }
    }
    .toolbar { EditButton() }
  }
}

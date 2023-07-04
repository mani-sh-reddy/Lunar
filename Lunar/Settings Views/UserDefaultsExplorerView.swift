//
//  UserDefaultsExplorerView.swift
//  Lunar
//
//  Created by Mani on 04/09/2023.
//

import Defaults
import Foundation
import SwiftUI

struct UserDefaultsExplorerView: View {
  var contents: [String: Any] {
    if Bundle.main.bundleIdentifier != nil {
      return UserDefaults.standard.dictionaryRepresentation()
    }
    return ["": ""]
  }

  var body: some View {
    List {
      ForEach(contents.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
        VStack(alignment: .leading) {
          Text(key)
            .font(.headline)
            .foregroundColor(.primary) // Key text color
          if let stringValue = value as? String {
            Text(stringValue)
              .font(.caption)
              .foregroundColor(.secondary) // String value text color
          } else {
            Text(String(describing: value))
              .font(.caption)
              .foregroundColor(.secondary) // Numeric value text color
          }
        }
      }
    }
    .navigationBarTitle("UserDefaults Contents")
    .listRowBackground(Color(.systemBackground)) // List background color
  }
}

#Preview {
  UserDefaultsExplorerView()
}

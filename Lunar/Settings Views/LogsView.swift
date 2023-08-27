//
//  LogsView.swift
//  Lunar
//
//  Created by Mani on 27/08/2023.
//

import SwiftUI

struct LogsView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("logs") var logs = Settings.logs
  
  var body: some View {
    List{
      ForEach(logs, id: \.self) { log in
        Text(log)
      }
    }
  }
}

struct LogsView_Previews: PreviewProvider {
  static var previews: some View {
    LogsView()
  }
}

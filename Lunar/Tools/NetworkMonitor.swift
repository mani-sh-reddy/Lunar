////
////  NetworkMonitor.swift
////  Lunar
////
////  Created by Mani on 16/07/2023.
////
//
// import Foundation
// import Network
// import SwiftUI
//
// class NetworkMonitor: ObservableObject {
//  let monitor = NWPathMonitor()
//  let queue = DispatchQueue(label: "Monitor")
//  @Published private(set) var connected: Bool = false
//
//  @MainActor
//  func checkConnection() {
//    monitor.pathUpdateHandler = { [weak self] path in
//      guard let self else { return }
//
//      DispatchQueue.main.async {
//        if path.status == .satisfied {
//          self.connected = true
//        } else {
//          self.connected = false
//        }
//      }
//    }
//    monitor.start(queue: queue)
//  }
// }

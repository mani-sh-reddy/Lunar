//
//  OfflineDownloaderView.swift
//  Lunar
//
//  Created by Mani on 25/11/2023.
//

import Defaults
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct OfflineDownloaderView: View {
  /// _ Commented out because causing stutter _
//  @Environment(\.dismiss) var dismiss

  @Binding var presentingView: Bool
  @State var downloaderSort: String = "Active"
  @State var downloaderType: String = "All"
  @State var pagesToDownload: Int = 1
  @State var currentlyDownloadingPage: Int = 1

  var body: some View {
    List {
      Section {
        HStack {
          Text("Downloader")
            .font(.title)
            .bold()
          Spacer()
          Button {
            presentingView = false
            /// _ Commented out because causing stutter _
//            dismiss()
          } label: {
            Image(systemSymbol: .xmarkCircleFill)
              .font(.largeTitle)
              .foregroundStyle(.secondary)
              .saturation(0)
          }
        }
      }
      .listRowBackground(Color.clear)

      Section {
        Text("Downloading Page \(currentlyDownloadingPage)/\(pagesToDownload)")
      }

      Section {
        Picker(selection: $downloaderSort, label: Text("Sort Query")) {
          Text("Active").tag("Active")
        }
        .pickerStyle(.menu)
        Picker(selection: $downloaderType, label: Text("Type Query")) {
          Text("All").tag("All")
        }
        .pickerStyle(.menu)
        Picker("Pages to Download", selection: $pagesToDownload) {
          ForEach(1 ..< 100) {
            Text("\($0) pages")
          }
        }
      }
      Section {
        Button {
          startDownload()
        } label: {
          Text("Download")
        }
      }
    }
  }

  func startDownload() {
    for page in 1 ... pagesToDownload {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        currentlyDownloadingPage = page
        PostsFetcher(
          sort: downloaderSort,
          type: downloaderType,
          communityID: 0,
          pageNumber: page,
          pageCursor: "",
          filterKey: "sortAndTypeOnly"
        ).loadContent()
      }
    }
  }
}

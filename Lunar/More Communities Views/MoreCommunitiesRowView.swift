//
//  MoreCommunitiesRowView.swift
//  Lunar
//
//  Created by Mani on 22/07/2023.
//

import Kingfisher
import SwiftUI

struct MoreCommunitiesRowView: View {
  var community: CommunityElement

  @State var showingPlaceholderAlert = false

  var body: some View {
    HStack {
      let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))
      KFImage(URL(string: community.community.icon ?? ""))
        .setProcessor(processor)
        .placeholder {
          Image(systemName: "books.vertical.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.gray)
        }
        .resizable()
        .frame(width: 30, height: 30)
        .clipShape(Circle())

      VStack(alignment: .leading) {
        Text(community.community.title).lineLimit(2)

      }.padding(.horizontal, 10)
      Spacer()
      Text(String("\(URLParser.extractDomain(from: community.community.actorID))"))
        .font(.caption)
        .foregroundStyle(.gray)
        .fixedSize()
    }
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      Button {
        showingPlaceholderAlert = true
      } label: {
        Label("go", systemImage: "chevron.forward.circle.fill")
      }.tint(.blue)
      Button {
        showingPlaceholderAlert = true
      } label: {
        Label("Hide", systemImage: "eye.slash.circle.fill")
      }.tint(.orange)
    }

    .contextMenu {
      Menu("Menu") {
        Button {
          showingPlaceholderAlert = true
        } label: {
          Text("Coming Soon")
        }
      }

      Button {
        showingPlaceholderAlert = true
      } label: {
        Text("Coming Soon")
      }

      Divider()

      Button(role: .destructive) {
        showingPlaceholderAlert = true
      } label: {
        Label("Delete", systemImage: "trash")
      }
    }
    .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
      Button("OK", role: .cancel) {}
    }
  }
}

//
//  InboxView.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Defaults
import Foundation
import MarkdownUI
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct InboxView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.privateMessagesRetrieved) var privateMessagesRetrieved
  @Default(.fontSize) var fontSize

  @ObservedResults(RealmPrivateMessage.self) var messages

  var body: some View {
    NavigationView {
      List {
        if messages.isEmpty || activeAccount.actorID.isEmpty {
          Text(activeAccount.actorID.isEmpty ? "Login to view messages" : "No messages found")
            .listRowBackground(Color.clear)
            .foregroundStyle(.secondary)
        } else {
          Section {
            ForEach(messages, id: \.messageID) { message in
              MessageItem(message: message)
            }
          }
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(.plain)
      .navigationTitle("Inbox")
      .onAppear {
        guard !privateMessagesRetrieved else { return }
        reloadMessages()
      }
      .refreshable {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
//        clearMessages()
        reloadMessages()
      }
      .onChange(of: activeAccount) { _ in
        clearMessages()
        reloadMessages()
      }
    }
  }

  func reloadMessages() {
    PrivateMessageFetcher(instance: URLParser.extractDomain(from: activeAccount.actorID)).loadContent()
    privateMessagesRetrieved = true
  }

  func clearMessages() {
    let realm = try! Realm()
    try! realm.write {
      let messages = realm.objects(RealmPrivateMessage.self)
      realm.delete(messages)
    }
    privateMessagesRetrieved = false
  }
}

enum messageDirection {
  case incoming
  case outgoing
}

struct MessageItem: View {
  @Default(.fontSize) var fontSize
  @Default(.activeAccount) var activeAccount

  @ObservedRealmObject var message: RealmPrivateMessage

  var messageDirection: messageDirection {
    message.creatorActorID == activeAccount.actorID ? .outgoing : .incoming
  }

  //  var fromTo: String {
  //    messageDirection == .incoming ? "from" : "to"
  //  }

  var name: String {
    messageDirection == .incoming ? message.creatorName : message.recipientName
  }

  var actorID: String {
    messageDirection == .incoming ? message.creatorActorID : message.recipientActorID
  }

  var avatar: String {
    messageDirection == .incoming ? message.creatorAvatar : message.recipientAvatar
  }

  var chatBubbleDirection: BubblePosition {
    messageDirection == .incoming ? .left : .right
  }

  var chatBubbleColor: Color {
    messageDirection == .incoming ? .messageBubbleBackgroundBlue : .messageBubbleBackgroundGray
  }

  var body: some View {
    ChatBubble(position: chatBubbleDirection, color: chatBubbleColor) {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          fromAvatar
          header
          Spacer()
        }
        messageBody
        timeAgoHeader
      }
    }
  }

  var header: some View {
    HStack(alignment: .firstTextBaseline, spacing: 1) {
      Text("\(name)")
        .bold()
        .fixedSize()

      Text("@\(URLParser.extractDomain(from: actorID))")
        .foregroundStyle(.secondary)
    }
    .lineLimit(1)
    .font(.caption)
  }

  var timeAgoHeader: some View {
    Text("\(message.messageTimeAgo) ago")
      .font(.caption)
      .foregroundStyle(.secondary)
  }

  @ViewBuilder
  var fromAvatar: some View {
    LazyImage(url: URL(string: avatar)) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
      } else {
        Image(systemSymbol: .personCircleFill)
          .resizable()
          .symbolRenderingMode(.hierarchical)
      }
    }
    .processors([.resize(width: 50)])

    .frame(width: 20, height: 20)
    .transition(.opacity)
  }

  var messageBody: some View {
    Text(message.messageContent)
      .font(.system(size: 15))
      .padding(.bottom, 3)
  }
}

#Preview {
  VStack {
    MessageItem(message: MockData().privateMessageIncoming)
    MessageItem(message: MockData().privateMessageIncoming)
  }
  .previewLayout(.sizeThatFits)
}
